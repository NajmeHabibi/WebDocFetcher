<?php

include("header.inc.php");
HTMLBegin();

$site_id_1 = -1;
if (isset($_GET['site_id'])) {
    $site_id_1 = (int)$_GET['site_id'];
} else {
    $site_id_1 = -1;
}

class be_docs
{
	public $id;		//
	public $site_id;		//
	public $page;		//
    public $link;
    public $title;
    public $topic;

	function be_docs() {}
}
$mysql = pdodb::getInstance();
		$k=0;
		$ret = array();
		$query = "select docs.id
				,docs.site_id
				,docs.page, docs.link , docs.title , docs.topic from sadaf.docs where docs.site_id=".$site_id_1;
                $res = $mysql->Execute($query);
                $i=0;
                while($rec=$res->fetch())
                {
                    $ret[$k] = new be_docs();
                    $ret[$k]->id=$rec["id"];
                    $ret[$k]->site_id=$rec["site_id"];
                    $ret[$k]->page=$rec["page"];
                    $ret[$k]->link=$rec["link"];
                    $ret[$k]->title=$rec["title"];
                    $ret[$k]->topic=$rec["topic"];
                    $k++;
                }
?>

<table id="PersonList" class="table table-sm table-stripped table-bordered">
<thead>
	<th>سند</th>
    <th>صفحه</th>
	<th>عنوان</th>
    <th>موضوع</th>
</thead>
<tbody>
<?
for($k=0; $k<count($ret); $k++)
{
	echo "<tr>";
    echo "	<td><a href=\"".$ret[$k]->link."\">".htmlentities($ret[$k]->link, ENT_QUOTES, 'UTF-8')."</a></td>";
    echo "	<td><a href=\"".$ret[$k]->page."\">".htmlentities($ret[$k]->page, ENT_QUOTES, 'UTF-8')."</a></td>";
    echo "	<td>".htmlentities($ret[$k]->title, ENT_QUOTES, 'UTF-8')."</td>";
    echo "	<td>".htmlentities($ret[$k]->topic, ENT_QUOTES, 'UTF-8')."</td>";
	echo "</tr>";
}
?>
</tbody>
</table>