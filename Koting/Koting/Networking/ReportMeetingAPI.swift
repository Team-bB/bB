//
//  ReportMemberAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/06/07.
//

import Foundation
import Alamofire

class ReportMeetingAPI {
    
    static let shared = ReportMeetingAPI()
    
    private init() {}
    
    func post(meetingId: Int, accountId: String, content: String, completion: @escaping (Result<ReportAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/report/meeting"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = [
            "meeting_id" : meetingId,
            "account_id" : accountId,
            "category" : content] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\n신고POST 성공")
      
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(ReportAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ ReportMeeting Codable Success ✅")
                    completion(.success(product))
                
                } catch {
                    debugPrint(response)
                    print("❗️ ReportMeeting Codable Error")
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
