import '../../../domain/auth/entities/user.dart';

class UserModel extends User 
{
  const UserModel
  ({
    required super.id,
    required super.email,
    required super.name,
  });


  //firebaseden gelen verinin mape cevrildigi yer
 // fromMap: dis dunyadan uygulamaya firebase okunurken toMap uygulamadan dis dunyaya firebase'e kaydedeilirdken
  factory UserModel.fromMap(Map<String, dynamic> map)
  {
    return UserModel
    (
      id: map['id'] ?? '', //firebase'den id verisini almayi dene eger bossa ya da hata varsa bos bir string koy
      email: map['email'] ?? '', 
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() //bu bir map key-value ciftlerinden olusur<string(key her zaman string), dynamic (value her sey olabilir)>
  {
    return 
    {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}