//
//  RequestAuthNumberAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class RequestAuthNumberAPI {
    
    static let shared = RequestAuthNumberAPI()

    private init() {}
    
    func get(phoneNumber: String, completion: @escaping (Result<String, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/auth/number?phoneNumber=\(phoneNumber)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseString { response in
            switch response.result {
            case .success(let result):
                debugPrint(response)
                print("✅ RequestAuthNumberAPI Success ✅")
                completion(.success(result))
                
            case .failure(let error):
                debugPrint(response)
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
