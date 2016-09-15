#############################################################################
##
##  ObjectsWithGenerators.gd                   ObjectsWithGenerators package
##
##  Copyright 2016,      Mohamed Barakat, University of Siegen
##                       Kamal Saleh, University of Siegen
##
##  Declaration stuff for categories with generators.
##
#############################################################################

#! @Chapter Intrinsic Categories

# our info class:
DeclareInfoClass( "InfoObjectsWithGenerators" );
SetInfoLevel( InfoObjectsWithGenerators, 1 );

####################################
#
#! @Section Categories
#
####################################

#! @Description
#!  The &GAP; category of objects with generators in a &CAP; category.
DeclareCategory( "IsCapCategoryObjectWithGenerators",
        IsCapCategoryObject );

#! @Description
#!  The &GAP; category of morphisms between objects with generators in a &CAP; category.
DeclareCategory( "IsCapCategoryMorphismWithGenerators",
        IsCapCategoryMorphism );

####################################
#
#! @Section Attributes
#
####################################

#! @Description
#!  The generators of the object <A>M</A> as a generalized embedding into the ambient object.
#! @Arguments M
DeclareAttribute( "GeneratorsWithRelationsOfObject",
        IsCapCategoryObjectWithGenerators );

#! @Description
#!  The generators of the object <A>M</A> as a generalized embedding into the ambient object.
#! @Arguments M
DeclareAttribute( "GeneratorsOfObject",
        IsCapCategoryObjectWithGenerators );

#! @Description
#!  The object underlying the object <A>M</A> with generators.
#! @Arguments M
DeclareAttribute( "ObjectWithoutGenerators",
        IsCapCategoryObjectWithGenerators );

####################################
#
#! @Section Constructors
#
####################################

#! @Description
#!  
#! @Arguments iota, A
DeclareOperation( "ObjectWithGenerators",
        [ IsGeneralizedMorphismByCospan, IsCapCategory ] );

#! @Description
#!  
#! @Arguments iota, A
DeclareOperation( "MorphismWithGenerators",
        [ IsCapCategoryObjectWithGenerators, IsCapCategoryMorphism, IsCapCategoryObjectWithGenerators ] );

#! @Description
#!  
#! @Arguments A
DeclareOperation( "CategoryWithGenerators",
        [ IsCapCategory ] );

#! @Description
#!  Display the generators of the object <A>M</A>
#! @Arguments M
DeclareOperation( "DisplayGenerators",
        [ IsCapCategoryObjectWithGenerators ] );

DeclareGlobalFunction( "ADD_FUNCTIONS_FOR_CATEGORY_WITH_GENERATORS" );
