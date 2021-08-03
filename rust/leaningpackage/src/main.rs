use std::io;
use rand::Rng;
use std::cmp;

fn main() {
    println!("{}",std::mem::size_of::<char>());
    let e=String::from("123");
    let mut e1=e;
    println!("{}",e1);
    println!("Hello, world!");
    let mut input=String::new();
    let secret_number:i8 = rand::thread_rng().gen();
    println!("secret_number:{}", secret_number);
    io::stdin().read_line(&mut input).expect("error");
    let mut n=Name{email:String::from("asdasdad")};
    n.email=String::from("123");
    n.Set(String::from("456"));
    println!("{:#?}",n);
    let a=IpKind::V4;
    match a{
        IpKind::V4=>println!("{:#?}",IpKind::V4),
        IpKind::V6=>println!("{:#?}",IpKind::V6),
    }
}

fn test(str: &mut String)->&mut String{
    println!("{}",str);
    str.push_str("hello world.");
    str.push('1');
    str
}

fn test1(str: &String)->usize{
    let bytes=str.as_bytes();
    for elem in bytes.iter().enumerate() {
    }
    str.len()
}

#[derive(Debug)]
struct Name{
    email:String
}

impl Name{
    fn Set(&mut self, v:String){
        self.email=v;
    }
}

#[derive(Debug)]
enum IpKind{
    V4,
    V6,
}