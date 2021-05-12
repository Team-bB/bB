//
//  WithdrawalAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/05/12.
//

import Foundation
import Alamofire

class WithdrawalAPI {
    
    static let shared = WithdrawalAPI()
    
    private init() {}
    
    func delete(completion: @escaping (Result<WithdrawalAPIResponse, Error>) -> (Void)) {
        
        let url = API.shared.BASE_URL + "/member"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let token = UserDefaults.standard.string(forKey: "accountId") else { return }
        
        //POST로 보낼 정보
        print(token)
        let params = ["account_id" : token] as Dictionary

        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }

        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                do {
                    let finalResult = try decoder.decode(WithdrawalAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ WithdrawalAPIResponse Codable Success ✅")
                    completion(.success(finalResult))
                
                } catch {
                    debugPrint(response)
                    print("❗️ WithdrawalAPIResponse Codable Error")
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

