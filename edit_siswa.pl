#!/usr/bin/perl

my $base_url = "http://localhost/";

print "Content-type:text/html\r\n\r\n";
		
local ($buffer, @pairs, $pair, $name, $value, %FORM);

# Read in text
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST"){
   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
} else {
   $buffer = $ENV{'QUERY_STRING'};
}

# Split information into name/value pairs

@pairs = split(/&/, $buffer);
foreach $pair (@pairs){
   ($name, $value) = split(/=/, $pair);
   $value =~ tr/+/ /;
   $value =~ s/%(..)/pack("C", hex($1))/eg;
   $FORM{$name} = $value;
}

my $id_siswa = $FORM{id_siswa};

use DBI;
use strict;

my $driver = "mysql";
my $database = "dbspp";
my $dsn = "DBI:$driver:database=$database";
my $userid = "root";
my $password = "your_password";

my $dbh = DBI->connect($dsn, $userid, $password) or die $DBI::errstr;

my $sth = $dbh->prepare("select * from siswa where id_siswa=$id_siswa; ");

$sth->execute();
while (my @row = $sth->fetchrow_array()) {
my ($id_siswa, $nis, $alamat, $nama_wali, $telp_wali, $nama_siswa ) = @row;
print "
<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta name='description' content=''>
    <meta name='author' content=''>
    <link rel='shortcut icon' href='$base_url/bootstrap/docs-assets/ico/favicon.png'>

    <title>Administrasi Siswa</title>

    <!-- Bootstrap core CSS -->
    <link href='$base_url/bootstrap/dist/css/bootstrap.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='$base_url/bootstrap/dist/css/navbar-fixed-top.css' rel='stylesheet'>

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src='$base_url/bootstrap/docs-assets/js/ie8-responsive-file-warning.js'></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src='https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js'></script>
      <script src='https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js'></script>
    <![endif]-->
  </head>

  <body>

    <!-- Fixed navbar -->
    <div class='navbar navbar-default navbar-fixed-top' role='navigation'>
      <div class='container'>
        <div class='navbar-header'>
          <button type='button' class='navbar-toggle' data-toggle='collapse' data-target='.navbar-collapse'>
            <span class='sr-only'>Toggle navigation</span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
          </button>
          <a class='navbar-brand' href='#'>Administrasi Siswa</a>
        </div>
        <div class='navbar-collapse collapse'>
          <ul class='nav navbar-nav'>
            <li ><a href='index.pl'>Home</a></li>
            <li><a href='form_tambah_siswa.pl'>Tambah Siswa</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>

    <div class='container'>
      <!-- Main component for a primary marketing message or call to action -->
      <div class='jumbotron'>
		  <h1>Edit Siswa</h1>

	<form action='proses_edit_siswa.pl' method='POST'>
	<input class='form-control' required autofocus  type='hidden' name='id_siswa' value='$id_siswa'/><br/>
	<small>NIS</small><br/>
	<input class='form-control' required autofocus  type='text' name='nis' value='$nis'/><br/>
	<small>Nama Siswa</small><br/>
	<input class='form-control' required autofocus  type='text' name='nama_siswa' value='$nama_siswa' /><br/>
	<small>Alamat</small><br/>
	<input class='form-control' required autofocus  type='text' name='alamat' value='$alamat'/><br/>
	<small>Nama Wali</small><br/>
	<input class='form-control' required autofocus  type='text' name='nama_wali' value='$nama_wali'/><br/>
	<small>Telp Wali</small><br/>
	<input class='form-control' required autofocus  type='text' name='telp_wali' value='$telp_wali'/>
	<br/>
	<br/>
	<input class='form-control btn-primary btn' required autofocus  type='submit' value='Submit'>
	</form>
	";
}

$sth->execute();
$sth->finish();
$dbh->commit;
