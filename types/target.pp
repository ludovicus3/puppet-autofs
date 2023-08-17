type Autofs::Target = Struct[{
    path => Stdlib::Absolutepath,
    host => Stdlib::Host,
    Optional[weight] => Integer[1],
}]
