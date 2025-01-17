<html>
<head>
<title>iVIREONS - identification of VIRions by Ensembles of Neural networkS </title>
<LINK REL="SHORTCUT ICON" HREF="http://segall-lab.sdsu.edu/ivireons/mag.jpg" />
<link rel="stylesheet" type="text/css" href="style.css"/>

<center> 
<h2>
<img src="/pics/ivireon.png" alt="nerding" width="300" height="200" /></img><br><br>
<u>i</u>dentification of <u>VIR</u>ions by <u>E</u>nsembles <u><b>o</b></u>f <u>N</u>eural network<u>S</u> 
</h2>
</center>
<hr>

<table>
<td>
<center> 
<img src="/pics/virus.jpg" alt="linup" width="420" height="320" usemap="#linup_map"/> 
<map id="linup_map" name="linup_map">
	<area shape="rect" coords="50,280,160,320" href="index.html" alt="dunno" /> 
	<area shape="rect" coords="160,280,260,320" href="background.html" alt="dunno" />
	<area shape="rect" coords="260,280,420,320" href="download.html" alt="dunno" />
</map>
</center>
</td>
<td>
iVIREONs uses ensembles of trained artificial neural networks to identify virion structural proteins by voting on translated open reading frames. Our networks correctly identify, with a high degree of accuracy, ORFs in GenBank that have annotations such as <q>capsid</q>, <q>tape measure</q>, <q>portal</q>, <q>tail</q>, <q>fiber</q>, <q>baseplate</q>, <q>connector</q>, <q>neck</q>, and <q>collar</q>. We have trained additional neural network ensembles to identify more specific classes of structural proteins, namely major capsid and tail proteins. Go to the background page of this site for more information about our training, testing, and validation methods.
<br/>
<br/>
To analyze coding sequences that have been translated to amino acids, use the <q>Browse</q> button below to select a FASTA-formatted file of protein sequences. Then press the <q>Identify Virion Proteins</q> button to present your protein sequences to our trained neural networks. Predictions made by our structural, major capsid, and tail protein network ensembles will be displayed as tab delimited text that can be easily pasted into an Excel spreadsheet. 
<br/>
<br/>
The development of this site is in progress. Please revisit this site for updates.
</td>
</table>

</head>

<body>

<hr>
<div id="main">

<form action="/cgi-bin/upload_and_predict.php" method="post"
enctype="multipart/form-data">

<!--
<label duh="checkboxes"/><h3>Protein Type:</h3>
<input type="checkbox" checked="yes" name="structural" value="structural" /><b> Structural</b> (Capsid, Tape Measure, Portal, Tail, Fber, Baseplate, Connector, Neck, or Collar) <br/>
<input type="checkbox" checked="yes" name="mcp" value="mcp" /><b> Major Capsid </b> <br/>
<input type="checkbox" checked="yes" name="tail" value="tail" /><b> Tail </b> <br/>
Filenames cannot have more than one "." due to a conflict with the format of Matlab data structures.
<br>
<hr>
-->
<h3>Upload a file of 500 (or less) translated protein coding sequences in FASTA format. </h3>
Filenames must have one of the following file extensions: ".faa", ".fasta", or ".txt".<br/>
<br>
<label for="file">Filename:</label>
<input type="file" name="file" id="file" />
<br />
<input type="submit" name="submit" value="Identify Virion Proteins" />
</form>

</div>
</body>
</html> 