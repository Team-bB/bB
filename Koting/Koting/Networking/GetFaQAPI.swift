//
//  GetFaQAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/05/28.
//

import Foundation
import Alamofire

class GetFaQAPI {
    
    static let shared = GetFaQAPI()

    private init() {}
    
    func get(completion: @escaping (Result<GetFaQAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/faq"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                do {
                    let product = try JSONDecoder().decode(GetFaQAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ FaQ Codable Success ✅")
                    completion(.success(product))
                } catch {
                    debugPrint(response)
                    print("❗️ FaQ Codable Error")
                    print(error)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                debugPrint(response)
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
