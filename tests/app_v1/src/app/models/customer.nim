import norm/model


type
  Customer* = ref object of Model


func newCustomer*(): Customer =
  Customer()
