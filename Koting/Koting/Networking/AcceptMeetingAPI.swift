//
//  AcceptMeetingAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/09.
//

import Foundation
import Alamofire

class AcceptMeetingAPI {
    static let shared = AcceptMeetingAPI()
    
    private init() {}
    
    func post(meetingId: Int?, completion: @escaping (Result<AcceptMeetingApplicantAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/applies" // 바꿔야함
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        guard let token = UserDefaults.standard.string(forKey: "accountId"),
              let meetingId = meetingId else { return }
        print(token)
        //POST로 보낼 정보
        let params = ["account_id" : token,
                      "meeting_id" : meetingId] as Dictionary // 유저 고유번호 만들어야할듯..???

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
                    let finalResult = try decoder.decode(AcceptMeetingApplicantAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ AcceptMeetingApplicantAPIResponse Codable Success ✅")
                    completion(.success(finalResult))
                
                } catch {
                    debugPrint(response)
                    print("❗️ AcceptMeetingApplicantAPIResponse Codable Error")
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
