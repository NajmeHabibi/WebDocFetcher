<?php

include("header.inc.php");
HTMLBegin();
class be_sites
{
    public $id;
	public $name;		//
	public $domain;		//
	public $is_ssl;		//
    public $depth;
    public $max_docs;
    public $doc_formats;
    public $status;

	function be_sites() {}
}
$mysql = pdodb::getInstance();
		$k=0;
		$ret = array();
		$query = "select sites.id , sites.name
				,sites.domain
				,sites.is_ssl, sites.depth , sites.max_docs , sites.doc_formats , sites.status from sadaf.sites  ";
                $res = $mysql->Execute($query);
                $i=0;
                while($rec=$res->fetch())
                {
                    $ret[$k] = new be_sites();
                    $ret[$k]->id=$rec["id"];
                    //echo $ret[$k]->id;
                    $ret[$k]->name=$rec["name"];
                    $ret[$k]->domain=$rec["domain"];
                    $ret[$k]->is_ssl=$rec["is_ssl"];
                    $ret[$k]->depth=$rec["depth"];
                    
                    $ret[$k]->max_docs=$rec["max_docs"];
                    $ret[$k]->doc_formats=$rec["doc_formats"];
                    $ret[$k]->status=$rec["status"];
                    $k++;
                }
?>

<table id="PersonList" class="table table-sm table-stripped table-bordered">
<thead>
	<th>نام</th>
    <th>دامین</th>
	<th>عمق</th>
    <th>حداکثر مستندات</th>
	<th>مدیریت</th>
</thead>
<tbody>
<?
for($k=0; $k<count($ret); $k++)
{
	echo "<tr>";
    echo "	<td><a href=\"docs.php?site_id=".$ret[$k]->id."\">".htmlentities($ret[$k]->name, ENT_QUOTES, 'UTF-8')."</a></td>";
    echo "	<td>".htmlentities($ret[$k]->domain, ENT_QUOTES, 'UTF-8')."</td>";
    echo "	<td>".htmlentities($ret[$k]->depth, ENT_QUOTES, 'UTF-8')."</td>";
    echo "	<td>".htmlentities($ret[$k]->max_docs, ENT_QUOTES, 'UTF-8')."</td>";
    echo "	<td>".htmlentities($ret[$k]->status, ENT_QUOTES, 'UTF-8')."</td>";
	echo "</tr>";
}
?>
</tbody>
</table>

