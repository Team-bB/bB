//
//  ApplyMeetingAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/05/01.
//

import Foundation
import Alamofire

class ApplyMeetingAPI {
    static let shared = ApplyMeetingAPI()
    
    private init() {}
    
    func post(meetingId: Int?, completion: @escaping (Result<ApplyMeetingAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/applies"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let token = UserDefaults.standard.string(forKey: "accountId"),
              let meetingId = meetingId else { return }
        print(token)
        //POST로 보낼 정보
        let params = ["account_id" : token,
                      "meeting_id" : meetingId] as Dictionary

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
                    let finalResult = try decoder.decode(ApplyMeetingAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ ApplyMeetingAPIResponse Codable Success ✅")
                    completion(.success(finalResult))
                
                } catch {
                    debugPrint(response)
                    print("❗️ ApplyMeetingAPIResponse Codable Error")
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
