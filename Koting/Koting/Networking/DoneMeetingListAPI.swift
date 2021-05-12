//
//  DoneMeetingListAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/09.
//

import Foundation
import Alamofire

class DoneMeetingListAPI {
    static let shared = DoneMeetingListAPI()
    
    private init() {}
    
    func get(accountID:String?,completion: @escaping (Result<DoneMeetingListAPIResponse, Error>) -> (Void)) {
        guard let accountID = accountID else { return }
        let url = API.shared.BASE_URL + "/applies/success?account_id=\(accountID)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                do {
                    let finalResult = try decoder.decode(DoneMeetingListAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ DoneMeetingListAPIResponse Codable Success ✅")
                    completion(.success(finalResult))

                } catch {
                    debugPrint(response)
                    print("❗️ DoneMeetingListAPI Codable Error ❗️")
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
