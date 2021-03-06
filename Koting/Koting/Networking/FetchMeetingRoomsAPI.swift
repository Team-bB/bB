//
//  FetchMeetingRooms.swift
//  Koting
//
//  Created by 임정우 on 2021/04/28.
//

import Foundation
import Alamofire

class FetchMeetingRoomsAPI {
    static let shared = FetchMeetingRoomsAPI()
    
    private init() {}
    
    func get(accountID:String?,completion: @escaping (Result<FetchMeetingRoomsAPIResponse, Error>) -> (Void)) {
        guard let accountID = accountID else { return print("없어용") }
        let url = API.shared.BASE_URL + "/meetings?account_id=\(accountID)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                do {
                    let finalResult = try decoder.decode(FetchMeetingRoomsAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ FetchMeetingRoomsAPIResponse Codable Success ✅")
                    completion(.success(finalResult))

                } catch {
                    debugPrint(response)
                    print("❗️ FetchMeetingRoomsAPIResponse Codable Error")
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
