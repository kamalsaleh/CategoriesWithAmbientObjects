#############################################################################
##
##  ObjectsWithGenerators.gi                   ObjectsWithGenerators package
##
##  Copyright 2016,      Mohamed Barakat, University of Siegen
##                       Kamal Saleh, University of Siegen
##
##  Implementation stuff for categories with generators.
##
#############################################################################

####################################
#
# representations:
#
####################################

DeclareRepresentation( "IsCapCategoryObjectWithGeneratorsRep",
        IsCapCategoryObjectWithGenerators and
        IsAttributeStoringRep,
        [ ] );

DeclareRepresentation( "IsCapCategoryMorphismWithGeneratorsRep",
        IsCapCategoryMorphismWithGenerators and
        IsAttributeStoringRep,
        [ ] );

####################################
#
# families and types:
#
####################################

# new families:
BindGlobal( "TheFamilyOfObjectsWithGenerators",
        NewFamily( "TheFamilyOfObjectsWithGenerators" ) );

BindGlobal( "TheFamilyOfMorphismsWithGenerators",
        NewFamily( "TheFamilyOfMorphismsWithGenerators" ) );

# new types:
BindGlobal( "TheTypeObjectWithGenerators",
        NewType( TheFamilyOfObjectsWithGenerators,
                IsCapCategoryObjectWithGeneratorsRep ) );

BindGlobal( "TheTypeMorphismWithGenerators",
        NewType( TheFamilyOfMorphismsWithGenerators,
                IsCapCategoryMorphismWithGenerators ) );

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( GeneratorsOfObject,
               [ IsCapCategoryObjectWithGeneratorsRep ],

  function( obj )
    local gens, rels;
    
    gens := NormalizedCospan( GeneratorsWithRelationsOfObject( obj ) );
    rels := ReversedArrow( gens );
    
    return PreCompose( Arrow( gens ), ColiftAlongEpimorphism( rels, CokernelProjection( KernelEmbedding( rels ) ) ) );
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( CategoryWithGenerators,
               [ IsCapCategory ],
               
  function( underlying_monoidal_category )
    local preconditions, category_weight_list, i,
          structure_record, object_constructor, morphism_constructor, 
          category_with_generators, zero_object;
    
    if not IsFinalized( underlying_monoidal_category ) then
        
        Error( "the underlying category must be finalized" );
        
    elif not IsMonoidalCategory( underlying_monoidal_category ) then
        
        Error( "the underlying category has to be a monoidal category" );
        
    elif not IsAdditiveCategory( underlying_monoidal_category ) then
        
        ## TODO: support the general case
        Error( "only additive categories are supported yet" );
        
    fi;
    
    category_with_generators := CreateCapCategory( Concatenation( Name( underlying_monoidal_category ), " with generators" ) );
    
    structure_record := rec(
      underlying_category := underlying_monoidal_category,
      category_with_attributes := category_with_generators
    );
    
    ## Constructors
    object_constructor := CreateObjectConstructorForCategoryWithAttributes(
              underlying_monoidal_category, category_with_generators, TheTypeObjectWithGenerators );
    
    structure_record.ObjectConstructor := function( object, attributes )
        local return_object;
        
        return_object := object_constructor( object, attributes );
        
        SetGeneratorsWithRelationsOfObject( return_object, attributes[1] );
        
        SetObjectWithoutGenerators( return_object, object );
        
        return return_object;
        
    end;
    
    structure_record.MorphismConstructor :=
      CreateMorphismConstructorForCategoryWithAttributes(
              underlying_monoidal_category, category_with_generators, TheTypeMorphismWithGenerators );
    
    ##
    category_weight_list := underlying_monoidal_category!.derivations_weight_list;
    
    ## ZeroObject with generators
    #preconditions := [ "UniversalMorphismIntoZeroObject",
    #                   "TensorProductOnObjects" ];
    preconditions := [  ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        zero_object := ZeroObject( underlying_monoidal_category );
        
        structure_record.ZeroObject :=
          function( underlying_zero_object )
              
              return [ AsGeneralizedMorphismByCospan( ZeroMorphism( underlying_zero_object, zero_object ) ) ];
              
          end;
    fi;
    
    ## Left action for DirectSum
    preconditions := [ "LeftDistributivityExpandingWithGivenObjects",
                       "DirectSum", #belongs to LeftDistributivityExpandingWithGivenObjects
                       "PreCompose" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.DirectSum :=
          function( obj_list, underlying_direct_sum )
            local generators_list, underlying_obj_list, structure_morphism;
            
            generators_list := List( obj_list, obj -> ObjectAttributesAsList( obj )[1] );
            
            underlying_obj_list := List( obj_list, UnderlyingCell );
            
            structure_morphism := 
              ConcatenationProduct( generators_list );
            
            return [ structure_morphism ];
            
          end;
        
    fi;
    
    ## Lift generators along monomorphism
    preconditions := [ "IdentityMorphism",
                       "PreCompose",
                       "TensorProductOnMorphismsWithGivenTensorProducts",
                       "TensorProductOnObjects", #belongs to TensorProductOnMorphisms
                       "LiftAlongMonomorphism" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.Lift :=
          function( mono, range )
            local generators_of_range;
            
            generators_of_range := ObjectAttributesAsList( range )[1];
            
            return [ PreCompose( mono, generators_of_range ) ];
            
          end;
        
    fi;
    
    ## Colift left action along epimorphism
    preconditions := [ "IdentityMorphism",
                       "PreCompose",
                       "TensorProductOnMorphismsWithGivenTensorProducts",
                       "TensorProductOnObjects", #belongs to TensorProductOnMorphisms
                       "ColiftAlongEpimorphism" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.Colift :=
          function( epi, source )
            local generators_of_source;
            
            generators_of_source := ObjectAttributesAsList( source )[1];
            
            return [ PreCompose( PseudoInverse( AsGeneralizedMorphismByCospan( epi ) ), generators_of_source ) ];
            
          end;
        
    fi;
    
    EnhancementWithAttributes( structure_record );
    
    ##
    InstallMethod( ObjectWithGenerators,
                   [ IsGeneralizedMorphismByCospan,
                     IsCapCategory and CategoryFilter( category_with_generators ) ],
                   
      function( object, attribute_category )
        
        return structure_record.ObjectConstructor( UnderlyingHonestObject( Source( object ) ), [ object ] );
        
    end );
    
    ##
    InstallMethod( MorphismWithGenerators,
                   [ IsCapCategoryObjectWithGenerators and ObjectFilter( category_with_generators ),
                     IsCapCategoryMorphism and MorphismFilter( underlying_monoidal_category ),
                     IsCapCategoryObjectWithGenerators and ObjectFilter( category_with_generators ) ],
                   
      function( source, underlying_morphism, range )
        
        return structure_record.MorphismConstructor( source, underlying_morphism, range );
        
    end );
    
    ## TODO: Set properties of category_with_generators
    
    ADD_FUNCTIONS_FOR_CATEGORY_WITH_GENERATORS( category_with_generators );
    
    ## TODO: Logic for category_with_generators
     
    Finalize( category_with_generators );
    
    return category_with_generators;
    
end );

##
InstallGlobalFunction( ADD_FUNCTIONS_FOR_CATEGORY_WITH_GENERATORS,
  
  function( category )
    ##
    AddIsEqualForObjects( category,
      function( object_with_generators_1, object_with_generators_2 )
        
        return IsCongruentForMorphisms( GeneratorsWithRelationsOfObject( object_with_generators_1 ), GeneratorsWithRelationsOfObject( object_with_generators_2 ) );
        
    end );
    
    ##
    AddIsEqualForMorphisms( category,
      function( morphism_1, morphism_2 )
        
        return IsEqualForMorphisms( UnderlyingCell( morphism_1 ), UnderlyingCell( morphism_2 ) );
        
    end );
    
    ##
    AddIsCongruentForMorphisms( category,
      function( morphism_1, morphism_2 )
        
        return IsCongruentForMorphisms( UnderlyingCell( morphism_1 ), UnderlyingCell( morphism_2 ) );
        
    end );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for an object with generators",
        [ IsCapCategoryObjectWithGeneratorsRep ],
        
  function( obj )
    
    ViewObj( ObjectWithoutGenerators( obj ) );
    Print( " with generators" );
    
end );

##
InstallMethod( ViewObj,
        "for a morphism between objects with generators",
        [ IsCapCategoryMorphismWithGeneratorsRep ],
        
  function( mor )
    
    ViewObj( UnderlyingCell( mor ) );
    
end );

##
InstallMethod( Display,
        "for an object with generators",
        [ IsCapCategoryObjectWithGeneratorsRep ],
        
  function( obj )
    
    Display( ObjectWithoutGenerators( obj ) );
    
end );

##
InstallMethod( DisplayGenerators,
        "for an object with generators",
        [ IsCapCategoryObjectWithGeneratorsRep ],
        
  function( obj )
    
    Display( GeneratorsOfObject( obj ) );
    
end );

##
InstallMethod( Display,
        "for a morphism between objects with generators",
        [ IsCapCategoryMorphismWithGeneratorsRep ],
        
  function( mor )
    
    Display( UnderlyingCell( mor ) );
    
end );
