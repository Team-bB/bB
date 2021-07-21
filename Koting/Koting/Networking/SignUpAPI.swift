//
//  SignUpAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/03/24.
//

import Foundation
import Alamofire

class SignUpAPI {
    
    static let shared = SignUpAPI()
    
    private init() {}
    
    func post(paramArray: Array<UITextField>, completion: @escaping (Result<SignUp, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/members"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let animalIndex = UserDefaults.standard.value(forKey: "animalIndex") as? String,
              let deviceToken = UserDefaults.standard.value(forKey: "device_token") as? String else { return }
    
        print("\n\n⭐️device_token : \(deviceToken)\n\n")
        
        //POST로 보낼 정보
        let params = [
            "nickname" : paramArray[0].text!,
            "phoneNumber" : UserAPI.shared.phoneNumber!,
            "college": paramArray[1].text!,
            "major": paramArray[2].text!,
            "sex": paramArray[3].text!,
            "mbti": paramArray[4].text!,
            "age": paramArray[5].text!,
            "height": paramArray[6].text!,
            "animalIdx": animalIndex,
            "email" :paramArray[7].text! + "@dongguk.edu",
            "device_token" : deviceToken] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\n회원가입 POST 성공")
      
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(SignUp.self, from: result)
                    debugPrint(response)
                    print("✅ SignUp Codable Success ✅")
                    completion(.success(product))
                
                } catch {
                    debugPrint(response)
                    print("❗️ SignUp Codable Error")
                    print(error)
                    completion(.failure(error))
                }
                
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
