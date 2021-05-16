//
//  DeleteMyMeetingAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/09.
//

import Foundation
import Alamofire

class DeleteMeetingRoomAPI {
    
    static let shared = DeleteMeetingRoomAPI()
    
    private init() {}
    
    func delete(completion: @escaping (Result<DeleteMeetingRoomAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/meetings"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let token = UserDefaults.standard.string(forKey: "accountId")
                else { return }
        
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
                    let finalResult = try decoder.decode(DeleteMeetingRoomAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ DeleteMeetingRoomAPIResponse Codable Success ✅")
                    completion(.success(finalResult))
                
                } catch {
                    debugPrint(response)
                    print("❗️ DeleteMeetingRoomAPIResponse Codable Error")
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

