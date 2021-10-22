<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$pokemonList = array();
$pokemon = null;
$p = "";
$regionalNumbers = loadRegionalNumbers();
$em = new EvolutionManager();

$lineNo = 0;
$startLine = 1;

$fh = fopen("pokemon.txt",'r');
while ($line = fgets($fh)) {
    if ($lineNo == $startLine) {
        break;
    }
    if(substr($line, 0, 1) == "#") {
        if($pokemon != null) {
            $pokemon->setFormImages(getFormImages($pokemon->getInternalName()));
            $rn = getRegionalNumber($pokemon->getInternalName(), $regionalNumbers);
            $pokemon->setRegionalNo($rn+1);
            $pokemon->setLocations(loadLocations($pokemon->getInternalName()));
            $pokemonList[$pokemon->getInternalName()] = $pokemon;
        }
        $pokemon = new Pokemon();
    } elseif (substr($line, 0, 1) == "[") { // Dex No
        $line = str_replace("[", "", $line);
        $line = str_replace("]", "", $line);
        $line = trim($line);
        $pokemon->setDexNo($line);
    } else {
        $lines = explode("=", $line);
        $lines[0] = trim($lines[0]);
        $lines[1] = trim($lines[1]);
        if($lines[0] == "Name") {
            $pokemon->setName($lines[1]);
        } else if($lines[0] == "InternalName") {
            $pokemon->setInternalName($lines[1]);
        } else if($lines[0] == "Pokedex") {
            $pokemon->setDescription($lines[1]);
        } else if($lines[0] == "Evolutions") {
            $lines[1] = explode(",", $lines[1]);
            $evos = array_chunk($lines[1], 3);
            foreach ($evos as $evo) {
                $evolution = new Evolution($evo[0], $evo[1], $evo[2], $pokemon->getInternalName());
                $pokemon->addEvolution($evolution);
                $em->addEvolution($evolution);
            }
        }
    }
}
fclose($fh);

getFormImages(strtoupper("Vivillon"));

if(isset($_POST['Submit'])) {
    $p = $_POST['poke'];
    getTemplate(strtoupper($_POST['poke']), $pokemonList, $em);
} else if(isset($_GET['wikiUpdate'])) {
    $p = $_GET['poke'];
    getTemplate(strtoupper($_GET['poke']), $pokemonList, $em);
    
    $login_Token = getLoginToken(); // Step 1
    loginRequest( $login_Token ); // Step 2
    $csrf_Token = getCSRFToken(); // Step 3
    updateWiki($csrf_Token, $_GET['content'], $_GET['poke']);
}

function updateWiki($csrf_Token, $content, $poke) {
    $endPoint = "https://pkmn-shadows.com/api.php";
    
    $params4 = [
        "action" => "edit",
        "title" => $poke,
        "text" => $content,
        "token" => $csrf_Token,
        "format" => "json"
    ];

    $ch = curl_init();

    curl_setopt( $ch, CURLOPT_URL, $endPoint );
    curl_setopt( $ch, CURLOPT_POST, true );
    curl_setopt( $ch, CURLOPT_POSTFIELDS, http_build_query( $params4 ) );
    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch, CURLOPT_COOKIEJAR, "cookie.txt" );
    curl_setopt( $ch, CURLOPT_COOKIEFILE, "cookie.txt" );
    
    $output = curl_exec( $ch );
    
    curl_close( $ch );
}

function getLoginToken() {
    $endPoint = "https://pkmn-shadows.com/api.php";

    $params1 = [
        "action" => "query",
        "meta" => "tokens",
        "type" => "login",
        "format" => "json"
    ];

    $url = $endPoint . "?" . http_build_query( $params1 );

    $ch = curl_init( $url );
    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch, CURLOPT_COOKIEJAR, "cookie.txt" );
    curl_setopt( $ch, CURLOPT_COOKIEFILE, "cookie.txt" );

    $output = curl_exec( $ch );
    curl_close( $ch );

    $result = json_decode( $output, true );
    return $result["query"]["tokens"]["logintoken"];
}

// Step 2: POST request to log in. Use of main account for login is not
// supported. Obtain credentials via Special:BotPasswords
// (https://www.mediawiki.org/wiki/Special:BotPasswords) for lgname & lgpassword
function loginRequest( $logintoken ) {
    $endPoint = "https://pkmn-shadows.com/api.php";

    $params2 = [
        "action" => "login",
        "lgname" => "Desbrina",
        "lgpassword" => "rUdraq-7zogni-cydjip",
        "lgtoken" => $logintoken,
        "format" => "json"
    ];

    $ch = curl_init();

    curl_setopt( $ch, CURLOPT_URL, $endPoint );
    curl_setopt( $ch, CURLOPT_POST, true );
    curl_setopt( $ch, CURLOPT_POSTFIELDS, http_build_query( $params2 ) );
    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch, CURLOPT_COOKIEJAR, "cookie.txt" );
    curl_setopt( $ch, CURLOPT_COOKIEFILE, "cookie.txt" );

    $output = curl_exec( $ch );
    curl_close( $ch );

}

// Step 3: GET request to fetch CSRF token
function getCSRFToken() {
    $endPoint = "https://pkmn-shadows.com/api.php";

    $params3 = [
        "action" => "query",
        "meta" => "tokens",
        "format" => "json"
    ];

    $url = $endPoint . "?" . http_build_query( $params3 );

    $ch = curl_init( $url );

    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch, CURLOPT_COOKIEJAR, "cookie.txt" );
    curl_setopt( $ch, CURLOPT_COOKIEFILE, "cookie.txt" );

    $output = curl_exec( $ch );
    curl_close( $ch );

    $result = json_decode( $output, true );
    return $result["query"]["tokens"]["csrftoken"];
}

function getFormImages($name) {
    $lineNo = 0;
    $startLine = 1;
    
    $text = "";
    $fh = fopen("pokemonforms.txt",'r');
    while ($line = fgets($fh)) {
        if ($lineNo == $startLine) {
            break;
        }
        if (substr($line, 0, 1) == "[") {
            $line = str_replace("[", "", $line);
            $line = str_replace("]", "", $line);
            $lines = explode(",", $line);
            $lines[0] = trim($lines[0]);
            $lines[1] = trim($lines[1]);
            if($lines[0] == $name) {
                $image = "[[File:" . $lines[0] . "_" . $lines[1] . ".png]]";
                $text = $text . " " . $image;
            }
        }
    }
    return $text;
}

function loadLocations($name) {
    $lineNo = 0;
    $mapName = "";
    $maps = array();
    $onMap = false;
    $lineNoRead = 0;
    $startLine = 1;
    $fh = fopen("encounters.txt",'r');
    while ($line = fgets($fh)) {
        if ($lineNoRead == $startLine) {
            break;
        }
        if(substr($line, 0, 1) == "#") { // Seperator
            if($onMap == true) {
                $maps[] = "* [[" . $mapName . "]]<br/>";
            }
            $lineNo = 0;
            $mapName = "";
            $onMap = false;
        }
        $lineNo = $lineNo + 1;
        if($lineNo == "2") { // Map Name
            $text = explode("#", $line);
            $mapName = trim($text[1]);
        }
        if ($lineNo > 2) {
            $newLine = explode(",", $line);
            if (count($newLine) > 2) {
                if(trim($newLine[1]) == $name) {
                    if($onMap == false) {
                        $onMap = true;
                    }
                }
            }
        }
    }
    if($onMap == true) {
        $maps[] = "* [[" . $mapName . "]]<br/>";
    }
    return $maps;
}

function loadLocationsEvos($name, $em) {
    $evos = array();
    foreach($em->getEvolutions() as $evo) {
        if($evo->getEvolveTo() == $name) {
            $evos[] = $evo;
        }
    }
    return $evos;
}

function getRegionalNumber($name, $regionalNumbers) {
    foreach($regionalNumbers as $key => $val) {
        $val = trim($val);
        if($val == $name) {
            return $key;
        }
    }
}

function loadRegionalNumbers() {
    $file = file_get_contents('regionaldexes.txt', true);
    
    $lineNo = 0;
    $startLine = 1;
    
    $regionals = explode(",", $file);
    foreach($regionals as $key => $value) {

        if ($lineNo == $startLine) {
            break;
        }
        $regionalNumbers[$key] = $value;
    }
    return $regionalNumbers;
}

function getTemplate($name, $pokemonList, $em) {
    foreach($pokemonList as $poke) {
        if($poke->getInternalName() == $name) {
            $poke->loadInTemplate($em);
        }
    }
}

class Pokemon {
    private $dexNo;
    private $name;
    private $internalName;
    private $description;
    private $evolutions = array();
    private $regionalNo;
    private $locations;
    private $formImages;
    
    function __construct() {
    }
    
    function getDexNo() { return $this->dexNo; }
    function setDexNo($value) { $this->dexNo = $value; }
    
    function getName() { return $this->name; }
    function setName($value) { $this->name = $value; }
    
    function getInternalName() { return $this->internalName; }
    function setInternalName($value) { $this->internalName = $value; }
    
    function getDescription() { return $this->description; }
    function setDescription($value) { $this->description = $value; }
    
    function getEvolutions() { return $this->evolutions; }
    function setEvolutions($value) { $this->evolutions = $value; }
    function addEvolution($value) { $this->evolutions[] = $value; }
    
    function setLocations($value) { $this->locations = $value; }
    
    function setRegionalNo($value) { $this->regionalNo = $value; }
    
    function setFormImages($value) { $this->formImages = $value; }
    
    function loadEvosForTemplate() {
        $text = "";
        
        foreach ($this->evolutions as $evo) {
            $eTo = $evo->getEvolveTo();
            $eTo = strtolower($eTo);
            $eTo = ucfirst($eTo);
            
            $method = $evo->getMethod();
            $method = strtolower($method);
            $method = ucfirst($method);
            if($method != "Level" && $method != "Trade") {
                $method="";
            }
            
            $value = $evo->getValue();
            $value = strtolower($value);
            $value = ucfirst($value);
            if($evo->getMethod()=="Item") {
                $value = "[[" . $value . "]]";
            }
            if ($evo->getMethod() == "Location") {
                $value = "Level up while on Map: " . $value;
            }
            if ($evo->getMethod() == "HappinessMoveType") {
                $value = "Level up while being happy with a " . $value . " type move";
            }
            if ($evo->getMethod() == "HappinessNight") {
                $value = "Level up while being happy during the night";
            }
            if ($evo->getMethod() == "HappinessDay") {
                $value = "Level up while being happy during the day";
            }
            if ($evo->getMethod() == "TradeItem") {
                $value = "Trade while holding a [[" . $value . "]]";
            }
            if ($evo->getMethod() == "Happiness") {
                $value = "Level up with high happiness";
            }
            
            
            $text = $text . "* [[" . $eTo . "]] - " . $method . " " . $value . "
";
        }
        
        return $text;
    }
    
    function loadLocationsForTemplate($em) {
        $text = "";
        
        foreach ($this->locations as $loc) {
            $text = $text . $loc;
        }
        $evos = loadLocationsEvos($this->internalName, $em);
        
        foreach ($evos as $evo) {
            $from = $evo->getEvolveFrom();
            $from = strtolower($from);
            $from = ucfirst($from);
            $text = $text .  "* Evolve [[" . $from . "]]";
        }
        
        return $text;
    }
    
    function loadInTemplate($em) {
        $text = "{{Pokemon|";
        $text = $text . "images=[[file: " . $this->internalName . ".png]]" . $this->formImages . "|";
        $text = $text . "description=" . $this->description . "|";
        $text = $text . "national number=" . $this->dexNo . "|";
        $text = $text . "regional number=" . $this->regionalNo . "|";
        $text = $text . "locations=" . $this->loadLocationsForTemplate($em) . "|";
        $text = $text . "evolutions=" . $this->loadEvosForTemplate() . "";
        $text = $text . "}}";
        
        echo $text;
        
        echo "<br/><br/>";
        echo '<a href="pokemon.php?wikiUpdate=true&poke='.$this->name.'&content='.$text.'" >Update Wiki</a>';
        echo "<br/><br/>";
        echo '<a href="https://pkmn-shadows.com/index.php?title='.$this->name.'&action=edit&venoscript=1" target="_blank " >Edit on Wiki (Source)</a>';
        echo "<br/><br/>";
        echo '<a href="https://pkmn-shadows.com/index.php?title='.$this->name.'" target="_blank " >View on Wiki</a>';
    }
}

class Evolution {
    private $evolveFrom;
    private $evolveTo;
    private $method;
    private $value;
    
    function __construct($evolveTo, $method, $value, $evolveFrom) {
        $this->evolveFrom = $evolveFrom;
        $this->evolveTo = $evolveTo;
        $this->method = $method;
        $this->value = $value;
    }
    
    function getEvolveTo() { return $this->evolveTo; }
    function getEvolveFrom() { return $this->evolveFrom; }
    function getMethod() { return $this->method; }
    function getValue() { return $this->value; }
}

class EvolutionManager {
    private $evolutions = array();
    
    function __construct() {
    }
    
    function getEvolutions() { return $this->evolutions; }
    function setEvolutions($value) { $this->evolutions = $value; }
    function addEvolution($value) { $this->evolutions[] = $value; }
}

?>
<p>&nbsp;</p>
<form id="form1" name="form1" method="post" action="">
    <input name="poke" type="text" id="poke" value="<?php echo $p; ?>" />
<input type="submit" name="Submit" value="Search" />
</form>
