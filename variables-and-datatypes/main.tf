# LOCALS

## Primitive types
locals {
  my_bool          = true
  my_number_int    = 1
  my_number_double = 1.23
  my_string        = "this is a string"

}

## Collection types (contain same type)
locals {
  my_list         = ["this", "is", "a", "list"] # ambiguous ; could be interpreted as list or tuple based on contents
  my_listier_list = tolist(["this", "is", "a", "list", 1]) # tolist forces consistent type ; 1 is coerced to "1"
  my-map = {
    this = "this"
    is   = "is"
    a    = "a"
    map  = "map"
  }
}

## Structural types (contain various types)
##  require a schema only if defined in a variable block
locals {
  my_tuple = [1, "one", true]
  my_tuple_containing_locals = [local.my_bool, local.my_number_int, local.my_string]
  my_object = {
    foo  = 1
    bar  = "foobar"
    baz  = ["fizz", "buzz"]
    2    = "foo" # ok
    true = false # ok
    # 1.23 = "woah" - not accessible
  }
}

# INPUT VARIABLES

variable "my_coerced_list" {
  type    = list(string)
  default = ["following primitive values are coerced to string : ", 1, true]
  # default = ["this map breaks terraform : ", {foo="bar"}] # complex data types cannot be cooerced so runtime error occurs
}


variable "my_list_numbers" {
  type    = list(number)
  default = [1, 1.23]
}

variable "my_map_any_schema" {
  type    = map(any)
  default = {
    foo = "bar"
  }
}

variable "my_map_defined_schema" {
  type    = object({
    foo = string
    bars = list(string)
  })
  default = {
    foo = "bar"
    bars = ["foo", "bar"]
  }
}