<?php

require_once "./simple_html_dom.php";

class DocCrawler
{
    private $domain;
    private $is_ssl;
    private $links;
    private $docs;
    private $doc_formats;
    private $simple_html_dom;
    public function __construct()
    {
        $this->simple_html_dom = new simple_html_dom();
        $this->doc_formats = array(
            'pdf',
            'docx'
        );
    }

    public function set_target($domain, $is_ssl=false){
        $this->domain = $domain;
        $this->is_ssl = $is_ssl;
    }

    private function head_request($url){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_NOBODY, true);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, true);
        $headers = curl_exec($ch);
        curl_close($ch);
        return $headers;
    }

    private function get_base_url(){
        return ($this->is_ssl ? 'https' : 'http') . '://' . $this->domain;
    }

    public function crawlDocs($depth){
        $this->links = array();
        $this->crawlLinks($this->get_base_url(),1, $depth);
        $this->docs = array();
        foreach ($this->links as $link){
            $cont = true;
            if (isset(parse_url($link)['path']) && isset(pathinfo(parse_url($link)['path'])['extension']))
                $cont = false;
            if ($cont)
                continue;
            if (in_array(pathinfo(parse_url($link)['path'])['extension'], $this->doc_formats))
                $this->docs[] = $link;
        }
        return $this->docs;
    }

    private function url_is_relative($url){
        return !(strpos($url, "/") === 0);
    }

    private function crawlLinks($url, $layer, $depth){
        $handle = curl_init();
        $options = Array(
            CURLOPT_RETURNTRANSFER => TRUE,
            CURLOPT_FOLLOWLOCATION => TRUE,
            CURLOPT_CONNECTTIMEOUT => 5,
            CURLOPT_TIMEOUT => 5,
            CURLOPT_MAXREDIRS => 20,
            CURLOPT_URL => $url,
        );
        curl_setopt_array($handle, $options);
        $response = curl_exec($handle);
        curl_close($handle);
        $this->simple_html_dom->load($response);

        foreach( $this->simple_html_dom->find('a') as $element){



            $encoded_href = preg_replace_callback('/[^\x20-\x7f]/', function($match) {
                return urlencode($match[0]);
            }, $element->href);
            if (filter_var($encoded_href, FILTER_VALIDATE_URL)){
                if (strpos($encoded_href, $this->domain) == false)
                    continue;
                $final_href = $encoded_href;
            }
            else{
                if ($this->url_is_relative($encoded_href)){
                    $final_href = $url . (substr($url, -1) == "/" ? "" : "/") . $encoded_href;
                }
                else{
                    $final_href = $this->get_base_url() . $encoded_href;
                }
            }
            if (in_array($final_href, $this->links))
                continue;
            $this->links[] = $final_href;
            if ($layer < $depth)
                $this->crawlLinks($final_href,$layer+1, $depth);
        }
    }
}