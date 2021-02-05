<?php

include("header.inc.php");
HTMLBegin();
require_once "./DocCrawler.php";

$docs = null;
$link = '';
$depth = '';
$site_id = null;
if (isset($_POST) && isset($_POST['link']) && isset($_POST['depth'])) {
    $link = $_POST['link'];
    $depth = $_POST['depth'];
    $name = $_POST['name'];
    $max_docs = $_POST['max_docs'];
    $query = "insert into sadaf.sites (name, domain, is_ssl, depth, max_docs, status) values (?, ?, ?, ?, ?, ?)";
    $mysql = pdodb::getinstance();
    $mysql->Prepare($query);
    $mysql->ExecuteStatement(array($name, $link , 1, $depth, $max_docs, 2));
    $site_id =  $mysql->Insert_ID();
    $model = new DocCrawler();
    $model->set_target($link, true, $max_docs);
    $docs = $model->crawlDocs($depth);

}
?>

<div class="container">
    <form action="" method="post" class="row mb-3" >
        <div class="col">
            <div class="form-group">
                <input type="text" name="name"
                       class="form-control"
                       placeholder="عنوان" required value="<?php echo $name; ?>">
                <input type="text" name="link"
                       class="form-control"
                       placeholder="لینک سایت بدون http , www" required value="<?php echo $link; ?>">
            </div>
        </div>
        <div class="col-4">

            <input type="number" name="depth"
                   class="form-control"
                   placeholder="حداکثر عمق خزش" required min="1" value="<?php echo $depth; ?>">
            <input type="number" name="max_docs"
                   class="form-control"
                   placeholder="حداکثر تعداد فایل واکشی" required min="1" value="<?php echo $max_docs; ?>">
        </div>

        <div class="col-3">
            <button type="submit" class="btn btn-primary w-100" >اضافه کردن سایت و شروع خزش</button>
        </div>
    </form>

    <?php
    if ($docs !== null) {
        if (empty($docs)) {
            ?>
            <p class="text-danger text-center" >No doc find</p>
            <?php
        } else {

            ?>

            <table class="table table-bordered table-striped" >
                <tbody>
                <?php foreach ($docs as $doc) {
                    $query = "insert into sadaf.docs (site_id, link, title, topic) values (?, ?, ?, ?)";
                    $mysql = pdodb::getinstance();
                    $mysql->Prepare($query);
                    $mysql->ExecuteStatement(array($site_id, $doc['link'],  $doc['title'], $doc['topic']));
                    ?>
                    <tr>
                        <td>
                            <a href="<?php echo $doc['link']; ?>"><?php echo $doc['link']; ?></a>
                        </td>
                    </tr>
                <?php } ?>
                </tbody>
            </table>

            <?php
        }
    }
    ?>
</div>
</html>



