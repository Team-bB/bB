import UIKit
class Person {
    var name: String = ""
    func breath() {
        print("숨을 쉽니다.")
    }
}

class Student: Person {
    var school: String = ""
    func goToSchool() {
        print("등교를 합니다.")
    }
}

class UniversityStudent: Student {
    var major: String = ""
    func goToLib() {
        print("도서관을 갑니다..")
    }
}

// 인스턴스 생성
var james: Person = Person()
var hana: Student = Student()
var joe: UniversityStudent = UniversityStudent()


var optionalCasted: Student?

print(type(of: james))
optionalCasted = hana as? UniversityStudent
print(optionalCasted)

