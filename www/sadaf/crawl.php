<?php

include("header.inc.php");
HTMLBegin();
require_once "./DocCrawler.php";

$links = null;
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
    $model->set_target($_POST['link'], true);
    $links = $model->crawlDocs($_POST['depth']);

}
?>

<div class="container">
    <form action="" method="post" class="row mb-3" >
        <div class="col">
            <div class="form-group">
                <input type="text" name="name"
                       class="form-control"
                       placeholder="name" required value="<?php echo $name; ?>">
                <input type="text" name="link"
                       class="form-control"
                       placeholder="link" required value="<?php echo $link; ?>">
            </div>
        </div>
        <div class="col-4">

            <input type="number" name="depth"
                   class="form-control"
                   placeholder="depth" required min="1" value="<?php echo $depth; ?>">
            <input type="number" name="max_docs"
                   class="form-control"
                   placeholder="max_docs" required min="1" value="<?php echo $max_docs; ?>">

        </div>

        <div class="col-3">
            <button type="submit" class="btn btn-primary w-100" >extract</button>
        </div>
    </form>

    <?php
    if ($links !== null) {
        if (empty($links)) {
            ?>
            <p class="text-danger text-center" >No doc find</p>
            <?php
        } else {

            ?>

            <table class="table table-bordered table-striped" >
                <tbody>
                <?php foreach ($links as $link) {
                    $query = "insert into sadaf.docs (site_id, page, link, title, topic) values (?, ?, ?, ?, ?)";
                    $mysql = pdodb::getinstance();
                    $mysql->Prepare($query);
                    $mysql->ExecuteStatement(array($site_id, "null" , $link, "null", "null"));
                    ?>
                    <tr>
                        <td>
                            <a href="<?php echo $link; ?>"><?php echo $link; ?></a>
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



