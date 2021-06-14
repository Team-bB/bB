//
//  GetOtherInfoAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/06/02.
//

import Foundation
import Alamofire

class GetOtherInfoAPI {
    
    static let shared = GetOtherInfoAPI()

    private init() {}
    
    func get(otherAccountId: String, completion: @escaping (Result<GetOtherInfoAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/members?account_id=\(otherAccountId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                do {
                    let finalResult = try JSONDecoder().decode(GetOtherInfoAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ GetOtherInfo Codable Success ✅")
                    completion(.success(finalResult))
                    
                } catch {
                    debugPrint(response)
                    print("❗️ GetOtherInfo Codable Error")
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
