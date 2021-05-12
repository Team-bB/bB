//
//  GetNoticeAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/05/12.
//

import Foundation
import Alamofire

class GetNoticeAPI {
    
    static let shared = GetNoticeAPI()

    private init() {}
    
    func get(completion: @escaping (Result<GetNoticeAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/notice"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                do {
                    let product = try JSONDecoder().decode(GetNoticeAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ Notice Codable Success ✅")
                    completion(.success(product))
                } catch {
                    debugPrint(response)
                    print("❗️ Notice Codable Error")
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
