SetPackageInfo( rec(

PackageName := "ObjectsWithGenerators",

Subtitle := "Categories with generators for CAP",

Version := Maximum( [
                   "2016.09.02", ## Mohamed's version
                   ## this line prevents merge conflicts
                   "2015.10.06", ## Sebas' version
                   ## this line prevents merge conflicts
                   ] ),

# this avoids git-merge conflicts
Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

ArchiveURL := Concatenation( "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/ObjectsWithGenerators-", ~.Version ),

ArchiveFormats := ".tar.gz",

Persons := [
  rec( 
    LastName      := "Barakat",
    FirstNames    := "Mohamed",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mohamed.barakat@rwth-aachen.de",
    WWWHome       := "http://www.mathematik.uni-kl.de/~barakat/",
    PostalAddress := Concatenation( [
                       "Lehrstuhl fuer Mathematik (Algebra), RWTH Aachen\n",
                       "Pontdriesch 10-16\n",
                       "52062 Aachen\n",
                       "Germany" ] ),
    Place         := "Aachen",
    Institution   := "RWTH Aachen University"
  ),
  
],

Status := "dev",

README_URL := 
  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/ObjectsWithGenerators/README.ObjectsWithGenerators",
PackageInfoURL := 
  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/ObjectsWithGenerators/PackageInfo.g",

PackageDoc := rec(
  BookName  := "ObjectsWithGenerators",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Intrinsic categories for CAP",
  Autoload  := false
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [
                   [ "AutoDoc", ">= 2013.12.04" ],
                   [ "ActionsForCAP", ">= 2013.09.20" ],
                   [ "GeneralizedMorphismsForCAP", ">= 2013.09.20" ],
                   [ "ToolsForHomalg", ">= 2015.09.23" ],
                   [ "GAPDoc", ">= 1.1" ]
                   ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := function( )
    return true;
  end,

Autoload := false,

Keywords := [ "categories", "intrinsic" ]

));
