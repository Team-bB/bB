//
//  RejectMeetingAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/10.
//

import Foundation
import Alamofire

class RejectMeetingAPI {
    static let shared = RejectMeetingAPI()
    
    private init() {}
    
    func post(accountID: String?, completion: @escaping (Result<RejectMeetingApplicantAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/applies/reject" // 바꿔야함
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let token = UserDefaults.standard.string(forKey: "accountId"),
              let accountID = accountID else { return }
        print(token)
        //POST로 보낼 정보
        let params = ["my_account_id" : token,
                      "your_meeting_id" : accountID] as Dictionary // 유저 고유번호 만들어야할듯..???

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
                    let finalResult = try decoder.decode(RejectMeetingApplicantAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ RejectMeetingApplicantAPIResponse Codable Success ✅")
                    completion(.success(finalResult))
                
                } catch {
                    debugPrint(response)
                    print("❗️ RejectMeetingApplicantAPIResponse Codable Error")
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

