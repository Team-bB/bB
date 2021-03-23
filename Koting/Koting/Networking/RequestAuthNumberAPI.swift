//
//  RequestPhoneAuth.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class RequestAuthNumberAPI {
    
    static let shared = RequestAuthNumberAPI()

    
    private init() {}
    
    func post(completion: @escaping (Result<String, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = ["phoneNumber" : UserAPI.shared.phoneNumber!] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success(let result):
                print(result)           // 결과 콘솔에 출력
                debugPrint(response)    // 디버그 프린트
                completion(.success(result))
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
