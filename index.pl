#!/usr/bin/perl

use DBI;
use strict;
my $driver = "mysql";
my $database = "dbspp";
my $dsn = "DBI:$driver:database=$database";
my $userid = "root";
my $password = "your_password";
my $dbh = DBI->connect($dsn, $userid, $password);	
my $base_url = "http://localhost/";

print "Content-type:text/html\r\n\r\n";
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
          <a class='navbar-brand'  href='#'>Administrasi Siswa</a>
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

        <h1>Data Siswa</h1>
        <br/>
<table class='table table-striped'>
	<tr>
		<th>NIS</th>
		<th>Nama Siswa</th>
		<th>Alamat</th>
		<th>Nama Wali</th>
		<th>Telp Wali</th>
		<th colspan='2'>Aksi</th>
	</tr>
";

my $sth = $dbh->prepare("select * from siswa;");
$sth->execute();
while (my @row = $sth->fetchrow_array()) {
   my ($id_siswa, $nis, $alamat, $nama_wali, $telp_wali, $nama_siswa ) = @row;
print "
	<tr>
   		<td>$nis</td>
   		<td>$nama_siswa</td>
   		<td>$alamat</td>
   		<td>$nama_wali</td>
   		<td>$telp_wali</td>
		<td>
			<form method='POST' action='edit_siswa.pl'>
				<input type='hidden' value='$id_siswa' name='id_siswa'>
				<input type='submit' value='Edit' class='btn btn-sm btn-primary'>
			</form>
		</td>
				<td>
					<form method='POST' action='proses_hapus_siswa.pl'>
						<input type='hidden' value='$id_siswa' name='id_siswa'>
						<input type='submit' value='Hapus' class='btn btn-sm btn-danger'>
					</form>
				</td>   		
	</tr>
   		";
}

print "
      </div>

    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src='$base_url/bootstrap/dist/js/jquery-1.10.2.js'></script>
    <script src='$base_url/bootstrap/dist/js/bootstrap.min.js'></script>
    
  </body>
</html>
";

