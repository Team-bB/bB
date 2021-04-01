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
        let url = API.shared.BASE_URL + "/signUp"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = [
                        "sex" : paramArray[0].text!,
                        "phoneNumber" : UserAPI.shared.phoneNumber!,
                        "college": paramArray[1].text!,
                        "major": paramArray[2].text!,
                        "age": paramArray[3].text!,
                        "height": paramArray[4].text!,
                        "mbti": paramArray[5].text!,
                        "email": paramArray[6].text! + domain
                    ] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\nPOST SUCCESS")
      
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(SignUp.self, from: result)
                    completion(.success(product))
                
                } catch {
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
