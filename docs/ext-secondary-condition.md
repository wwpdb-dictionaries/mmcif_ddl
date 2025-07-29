# mmCIF DDL Secondary Keys and Conditional Mandatory Extensions

## Secondary Keys

### Purpose 
Allow for categories to have unique, non-mandatory, non-primary keys.

### Overview
The category_secondary_key category has three items, all of which are required as keys for the category.

1. category_secondary_key.id </br>

    The category_secondary_key.id item is a child of the "_category.id" item, and consists of the category id that contains the secondary keys. This item is implicit and does not need to be explicitly defined.

2. category_secondary_key.key_id </br>

    The category_secondary_key.key_id item is a mandatory item that is designed to take a single word to be used as an identifier for a specific secondary key. If the category_secondary_key category is being looped through and two rows have the same value for key_id, the two rows contain information that is connected to the same secondary key.

3. category_secondary_key.item_name </br>

    The category_secondary_key.item_name item is a mandatory item that is designed to hold the name of an item that is to be used as a component of the secondary key. This is the item that will be directly used/evaluated as a member of a secondary key.

### DDL2 Implementation
To create secondary key values for a category, both _category_secondary_key.key_id and _category_secondary_key.item_name should be defined inside the category of interest. The category_secondary_key category has been designed to allow for the presence of multiple pairs of key_id and item_name values through looping of the category_secondary_key category. 

```
save_entity_poly_seq

loop_
_category_secondary_key.key_id
_category_secondary_key.item_name
    id1   "_entity_poly_seq.entity_id"  
    id1   "_entity_poly_seq.num"
    id2   "_entity_poly_seq.mon_id"
    id2   "_entity_poly_seq.num"
```

The values for _category_secondary_key.key_id can be anything as long as it is comprised of a single word. The values for _category_secondary_key.item_name must correspond to the name of an item that is present in the category of interest. The values for both of these items must be present; missing or inapplicable values are not allowed. In the case of the example above, two secondary key combinations will be created. The first one, indicated by "id1", will contain combinations of values for the "_entity_poly_seq.entity_id" and "_entity_poly_seq.num" items. The second one (indicated by "id2) will contain combinations of values for "_entity_poly_seq.mon_id" and "_entity_poly_seq.num". 

### Enforcement of Secondary Keys
When defining and checking for secondary keys in a Cif file using dictionary-related tools, a pair is created containing the key_id item and the item_name item for each row of the loop. From this, item_name values are separated into vectors based on their key_id so that a given vector contains a list of all item names that were paired with the same key_id. A map containing all of the vectors is created and iterated through. For each vector in the map, the values of the category table are checked row by row based on the columns associated with each item_name in the vector. If the combination of all values in a row is unique, the secondary key is valid. 

Unknown values are allowed in item_name columns as long as the combination of all secondary keys is unique. Inapplicable values are treated as unknown values, so if two rows have identical values for all item_name columns save for one row having a "?" and the other having a "." in the same column, the rows are treated as duplicates.

#### Example 1 for key_id "id1"
Below is a representation of the entity_poly_seq category table
|Row     |_entity_poly_seq.entity_id |...|_entity_poly_seq.num |
|--------|---------------------------|---|---------------------|
|0       |1                          |...|1                    |
|1       |1                          |...|2                    |
|2       |1                          |...|3                    |
|3       |2                          |...|1                    |
|4       |2                          |...|2                    |
|5       |2                          |...|3                    |

For each row in the table: </br>
Secondary key value for row 0: "1 1" </br>
Secondary key value for row 1: "1 2" </br>
Secondary key value for row 2: "1 3" </br>
Secondary key value for row 3: "2 1" </br>
Secondary key value for row 4: "2 2" </br>
Secondary key value for row 5: "2 3"

While there are repeated values in both columns, all combinations are unique, so all of the secondary key values are valid

#### Example 2 for key_id "id1" - Missing Values
Below is a representation of the entity_poly_seq category table for a different Cif file
|Row     |_entity_poly_seq.entity_id |...|_entity_poly_seq.num |
|--------|---------------------------|---|---------------------|
|0       |1                          |...|1                    |
|1       |1                          |...|2                    |
|2       |1                          |...|3                    |
|3       |2                          |...|?                    |
|4       |2                          |...|.                    |
|5       |2                          |...|3                    |

For each row in the table: </br>
Secondary key value for row 0: "1 1" </br>
Secondary key value for row 1: "1 2" </br>
Secondary key value for row 2: "1 3" </br>
Secondary key value for row 3: "2 ?" </br>
Secondary key value for row 4: "2 ?" </br>
Secondary key value for row 5: "2 3"

In the "_entity_poly_seq.num" column, rows 3 and 4 both contain an empty value. Even though row 3 is marked as missing ("?") and row 4 is marked as inapplicable ("."), the values for the item column are evaluated to be identical as they are both empty regardless of the reason why. Since the values in the "_entity_poly_seq.entity_id" column are also the same for both rows, the resulting combination of secondary key item values is identical, so the secondary key values are not valid.


## Conditional Mandatory Categories and Items

### Purpose
Allow for categories and items that can be mandatory or not mandatory based on whether a condition is met (e.g. a target item contains a certain value).

### Overview
Two categories were created to handle conditional madatory data: pdbx_category_conditional_mandatory and pdbx_item_conditional_mandatory, which addresses conditional mandatory categories and conditional mandatory items respectively. Both categories contain two items; an item linked to the name of the conditionally mandatory category/item in question and an item linked to an identifier called the context id.

#### pdbx_category_conditional_mandatory (Conditional Mandatory Categories)
The items present in pdbx_category_conditional_mandatory are _pdbx_category_conditional_mandatory.category_id (a child of _category.id), which contains the category id of the conditional mandatory category, and _pdbx_category_conditional_mandatory.context_id (a child of _pdbx_conditional_context_list.context_id), which contains a single word to be used as an identifier. Both items are keys for the category.

#### pdbx_item_conditional_mandatory (Conditional Mandatory Items)
The items present in pdbx_item_conditional_mandatory are _pdbx_item_conditional_mandatory.item_name (a child of _item.name), which contains the item name of the conditional mandatory item, and _pdbx_item_conditional_mandatory.context_id (a child of _pdbx_conditional_context_list.context_id), which contains a single word to be used as an identifier. Both items are keys for the category.

### DDL2 Implementation

#### Conditional Mandatory Categories DDL2 Implementation and Example
The pdbx_category_conditional_mandatory category must be included in the definition of the conditional mandatory category. The pdbx_category_conditional_mandatory category can be looped if needed, allowing for multiple conditional mandatory category-context id pairs. 

```
save_entity_poly

_pdbx_category_conditional_mandatory.context_id  TYPE_POLY
_pdbx_category_conditional_mandatory.category_id entity_poly

...

```
By defining "_pdbx_category_conditional_mandatory.category_id" with a value of "entity_poly" inside of the "entity_poly" category, the category is established as a conditional mandatory category. The "_pdbx_category_conditional_mandatory.context_id" item contains the identifier for the conditional mandatory category, which is necessary for defining and finding the condition needed for the category to be treated as mandatory.

To determine whether a conditional mandatory category should be required, the pdbx_conditional_context_list (introduced in the mmCIF DDL PDBx Contextual Extensions extension)
category must also be defined within the conditional mandatory category. For the implementation of pdbx_category_conditional_mandatory above, this may look like:
```
save_entity_poly

loop_
_pdbx_conditional_context_list.ordinal_id
_pdbx_conditional_context_list.context_id
_pdbx_conditional_context_list.target_item_name
_pdbx_conditional_context_list.target_item_value
_pdbx_conditional_context_list.cmp_op
_pdbx_conditional_context_list.log_op
    1  TYPE_POLY  "_entity.type"  "polymer" =  ?     

...

```
The pdbx_conditional_context_list category contains information on the condition to be searched for to determine whether the item should be treated as mandatory or not.
- The "_pdbx_conditional_context_list.ordinal_id" item contains an integer used to order the list of values for each item in the "pdbx_conditional_context_list" category.
- The "_pdbx_conditional_context_list.context_id" item must match the context id value contained in the "_pdbx_item_conditional_mandatory.context_id" item, otherwise the condition to be tested will not be found. 
- The "_pdbx_conditional_context_list.target_item_name" item contains the item name for the item that is to be evaluated by the conditional.
- The "_pdbx_conditional_context_list.target_item_value" item contains the value the target item needs to have in order for the condition to be fulfilled. 
- The "_pdbx_conditional_context_list.cmp_op" item contains the comparison operators for the condition.
- The "_pdbx_conditional_context_list.log_op" item contains the logical operators for the condition.

In the case above, the category "entity_poly" will be required if the value of "_entity.type" is equal to "polymer", linked by the context id "TYPE_POLY". There is no logical operator for this comparison.

#### Conditional Mandatory Items DDL2 Implementation and Example
The structure for defining conditional mandatory items using the pdbx_item_conditional_mandatory category is similar to that of using pdbx_category_conditional_mandatory for categories. The pdbx_item_conditional_mandatory category must be included in the definition of the item that is to be conditionally mandatory. The pdbx_item_conditional_mandatory category can be looped if needed, allowing for multiple conditional mandatory item-context id pairs.

```
save__struct_ref.pdbx_align_begin

_pdbx_item_conditional_mandatory.context_id  DB_UNP
_pdbx_item_conditional_mandatory.item_name   "_struct_ref.pdbx_align_begin"

...

```
By defining "_pdbx_item_conditional_mandatory.item_name" with a value of "_struct_ref.pdbx_align_begin" inside of the "_struct_ref.pdbx_align_begin" item, the item is established as a conditional mandatory item. The "_pdbx_item_conditional_mandatory.context_id" item contains the identifier for the conditional mandatory item, which is necessary for defining and finding the condition needed for the item to be treated as mandatory.

To determine whether a conditional mandatory item should be required, the pdbx_conditional_context_list (introduced in the mmCIF DDL PDBx Contextual Extensions extension)
category must also be defined within the conditional mandatory item. For the implementation of pdbx_item_conditional_mandatory above, this may look like:
```
save__struct_ref.pdbx_align_begin

loop_
_pdbx_conditional_context_list.ordinal_id
_pdbx_conditional_context_list.context_id
_pdbx_conditional_context_list.target_item_name
_pdbx_conditional_context_list.target_item_value
_pdbx_conditional_context_list.cmp_op
_pdbx_conditional_context_list.log_op
    1  DB_UNP  "_struct_ref.db_name"  "UNP" =  ?   

...

```
The pdbx_conditional_context_list category contains information on the condition to be searched for to determine whether the item should be treated as mandatory or not. 
- The "_pdbx_conditional_context_list.ordinal_id" item contains an integer used to order the list of values for each item in the "pdbx_conditional_context_list" category.
- The "_pdbx_conditional_context_list.context_id" item must match the context id value contained in the "_pdbx_item_conditional_mandatory.context_id" item, otherwise the condition to be tested will not be found. 
- The "_pdbx_conditional_context_list.target_item_name" item contains the item name for the item that is to be evaluated by the conditional.
- The "_pdbx_conditional_context_list.target_item_value" item contains the value the target item needs to have in order for the condition to be fulfilled. 
- The "_pdbx_conditional_context_list.cmp_op" item contains the comparison operators for the condition.
- The "_pdbx_conditional_context_list.log_op" item contains the logical operators for the condition.

In the case above, the item "_struct_ref.pdbx_align_begin" will be required if the value of "_struct_ref.db_name" is equal to "UNP", linked by the context id "DB_UNP". There is no logical operator for this comparison.

### Enforcement of Conditional Mandatory Categories/Items
Using dictionary-related tools (i.e. the cpp-dict-pack repository on GitHub), categories/items are determined to be conditionally mandatory by first getting the name of the category/item in question and obtaining all of the context ids associated with that name. For each obtained context id, the condition connected to it (determined by the contents of the pdbx_conditional_context_list category) is tested. If the condition is fulfilled, the conditional mandatory category/item is marked as required; if it is not fulfilled, the next context id is tested. If the context id being tested is the last one in the list and the condition connected to it is not fulfilled, the conditional mandatory category/item is marked as not required.

#### Example for Conditional Mandatory Category "entity_poly"
Below is a section of the Cif file for human deoxyhemoglobin (PDB ID: 4HHB; Extended PDB ID: pdb_00004hhb) for the entity category.
```
loop_
_entity.id 
_entity.type 
_entity.src_method 
_entity.pdbx_description 
_entity.formula_weight 
_entity.pdbx_number_of_molecules 
_entity.pdbx_ec 
_entity.pdbx_mutation 
_entity.pdbx_fragment 
_entity.details 
1 polymer     man 'Hemoglobin subunit alpha'        15150.353 2   ? ? ? ? 
2 polymer     man 'Hemoglobin subunit beta'         15890.198 2   ? ? ? ? 
3 non-polymer syn 'PROTOPORPHYRIN IX CONTAINING FE' 616.487   4   ? ? ? ? 
4 non-polymer syn 'PHOSPHATE ION'                   94.971    2   ? ? ? ? 
5 water       nat water                             18.015    221 ? ? ? ? 
#
```
For conditional mandatory categories, only one instance of the target item (in this case "_entity.type") has to fulfill the condition in order for the category to be required. If the conditional is never satisfied, the category will not be required. If the condition is satisfied for the category but the category is missing from the Cif file, an error will be thrown stating that the category is conditionally mandatory, but is not in datablock.

In this example, since the first and second row have a value of "polymer" for "_entity.type", the category "entity_poly" will be required. If only the third, fourth, and fifth rows were present in the file, the category would not be required as none of these rows have a value of "polymer" for "_entity.type".

#### Examples for Conditional Mandatory Item "_struct_ref.pdbx_align_begin"

##### Example 1 for Conditional Mandatory Item "_struct_ref.pdbx_align_begin" - Logic for Requiring Item Instances (Both Instances Fulfill the Condition)
Below is a section of the Cif file for human deoxyhemoglobin (PDB ID: 4HHB; Extended PDB ID: pdb_00004hhb) for the struct_ref category.
```
loop_
_struct_ref.id 
_struct_ref.db_name 
_struct_ref.db_code 
_struct_ref.pdbx_db_accession 
_struct_ref.pdbx_db_isoform 
_struct_ref.entity_id 
_struct_ref.pdbx_seq_one_letter_code 
_struct_ref.pdbx_align_begin 
1 UNP HBA_HUMAN P69905 ? 1 
;VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR
;
2 
2 UNP HBB_HUMAN P68871 ? 2 
;VHLTPEEKSAVTALWGKVNVDEVGGEALGRLLVVYPWTQRFFESFGDLSTPDAVMGNPKVKAHGKKVLGAFSDGLAHLDN
LKGTFATLSELHCDKLHVDPENFRLLGNVLVCVLAHHFGKEFTPPVQAAYQKVVAGVANALAHKYH
;
2 
# 
```
Unlike conditional mandatory categories, the requiring of conditional mandatory items is determined based on individual instances of the item. For example, if the condition for one instance of a conditional mandatory item is fulfilled, that instance is required. While that instance is required, it does not make subsequent instances of the conditional mandatory item required by default.

In the case of Example 1, both instances of the "_struct_ref.pdbx_align_begin" item are conditionally mandatory as the value for their respective instance of "_struct_ref.db_name" is equal to "UNP". 

##### Example 2 for Conditional Mandatory Item "_struct_ref.pdbx_align_begin" - Logic for Requiring Item Instances (Only One Instance Fulfills the Condition)
In the modified Cif information for 4HHB below, one instance of _struct_ref.db_name has a value of "UNP" while the second instance has a value of "PDB". 
```
loop_
_struct_ref.id 
_struct_ref.db_name 
_struct_ref.db_code 
_struct_ref.pdbx_db_accession 
_struct_ref.pdbx_db_isoform 
_struct_ref.entity_id 
_struct_ref.pdbx_seq_one_letter_code 
_struct_ref.pdbx_align_begin 
1 UNP HBA_HUMAN P69905 ? 1 
;VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR
;
2 
2 PDB HBB_HUMAN 4HHB ? 2 
;VHLTPEEKSAVTALWGKVNVDEVGGEALGRLLVVYPWTQRFFESFGDLSTPDAVMGNPKVKAHGKKVLGAFSDGLAHLDN
LKGTFATLSELHCDKLHVDPENFRLLGNVLVCVLAHHFGKEFTPPVQAAYQKVVAGVANALAHKYH
;
? 
# 
```
Since only the first instance of the item fulfills the condition ("_struct_ref.db_name" = "UNP"), only that instance is required. The second instance has a value of "PDB", which does not fulfill the condition, so it is treated as not mandatory. If the "_struct_ref.pdbx_align_begin" item was unconditionally mandatory, the second instance would result in an error as the value is listed as unknown. However, since the item is conditional mandatory and the condition for that instance is not fulfilled, no error is produced.

##### ____________________________________________________________________________
There are two potential ways for a conditionally mandatory item to result in an error: 
1. the condition for a conditionally mandatory item is fulfilled but the value for the conditionally mandatory item is missing in the data
2. the condition for a conditionally mandatory item is fulfilled but the conditionally mandatory item itself is missing from the category 

##### Example 3 for Conditional Mandatory Item "_struct_ref.pdbx_align_begin" - Missing Conditionally Mandatory Item Values
For the first case involving a missing value, look at the example below:
```
loop_
_struct_ref.id 
_struct_ref.db_name 
_struct_ref.db_code 
_struct_ref.pdbx_db_accession 
_struct_ref.pdbx_db_isoform 
_struct_ref.entity_id 
_struct_ref.pdbx_seq_one_letter_code 
_struct_ref.pdbx_align_begin 
1 UNP HBA_HUMAN P69905 ? 1 
;VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR
;
? 
```
In this example, the value for "_struct_ref.db_name" satisfies the conditional but the value for "_struct_ref.pdbx_align_begin" is missing (indicated by a question mark). Since missing values are not allowed for mandatory items, an error stating that the instance of the conditionally mandatory item has invalid value.

##### Example 4 for Conditional Mandatory Item "_struct_ref.pdbx_align_begin" - Missing Conditionally Mandatory Items
For the second case involving a missing item, look at the example below:
```
loop_
_struct_ref.id 
_struct_ref.db_name 
_struct_ref.db_code 
_struct_ref.pdbx_db_accession 
_struct_ref.pdbx_db_isoform 
_struct_ref.entity_id 
_struct_ref.pdbx_seq_one_letter_code 
1 UNP HBA_HUMAN P69905 ? 1 
;VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR
; 
```
In this example, the value for "_struct_ref.db_name" satisfies the conditional but "_struct_ref.pdbx_align_begin" 
is missing from the category entirely. Since mandatory items cannot be missing, an error stating that the item is conditionally mandatory, but is not found in the category.
