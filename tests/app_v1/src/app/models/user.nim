import norm/model


type
  User* = ref object of Model
    email*: string


func newUser*(email: string): User =
  User(email: email)
