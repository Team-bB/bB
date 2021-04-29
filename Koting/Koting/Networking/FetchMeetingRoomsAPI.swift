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
    
    func get(completion: @escaping (Result<FetchMeetingRoomsAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/meetings"
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
                    completion(.success(finalResult))

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
