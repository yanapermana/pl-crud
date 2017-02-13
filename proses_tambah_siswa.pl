#!/usr/bin/perl
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

my $nis = $FORM{nis};
my $nama_siswa  = $FORM{nama_siswa};
my $alamat = $FORM{alamat};
my $nama_wali = $FORM{nama_wali};
my $telp_wali = $FORM{telp_wali};

use DBI;
use strict;

my $driver = "mysql";
my $database = "dbspp";
my $dsn = "DBI:$driver:database=$database";
my $userid = "root";
my $password = "your_password";

my $dbh = DBI->connect($dsn, $userid, $password) or die $DBI::errstr;

my $sth = $dbh->prepare("insert into siswa values ('','$nis', '$alamat', '$nama_wali', '$telp_wali', '$nama_siswa'); ");

$sth->execute();
$sth->finish();
$dbh->commit;

print "
<script>
alert('Data siswa berhasil ditambahkan');
</script>
<meta http-equiv='refresh' content='0; url=index.pl'>
";
