//
//  MyMeetingListAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/05/01.
//

import Foundation
import Alamofire

class MyMeetingListAPI {
    static let shared = MyMeetingListAPI()
    
    private init() {}
    
    func get(completion: @escaping (Result<MyMeetingListAPIResponse, Error>) -> (Void)) {
        guard let token = UserDefaults.standard.string(forKey: "accountId") else { return }
        let url = API.shared.BASE_URL + "/applies?account_id=" + token
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                do {
                    let finalResult = try decoder.decode(MyMeetingListAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ MyMeetingListAPIResponse Codable Success ✅")
                    completion(.success(finalResult))

                } catch {
                    debugPrint(response)
                    print("❗️ MyMeetingListAPI Codable Error ❗️")
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
