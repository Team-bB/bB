//
//  MeetingListAndMyInfoAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/25.
//

import Foundation
import Alamofire

//class MeetingListAndMyInfoAPI {
//
//    static let shared = MeetingListAndMyInfoAPI()
//    
//    private init() {}
//
//    func post(completion: @escaping (Result<APIResponse, Error>) -> (Void)) {
//        let url = API.shared.BASE_URL + "/checkStatus"
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//
//        //POST로 보낼 정보
//        guard let accountId = UserDefaults.standard.string(forKey: "accountId") else { return }
//
//        let params = ["account_id" : accountId] as Dictionary
//
//        // httpBody에 parameters 추가
//        do {
//            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            print("http Body Error")
//        }
//
//        AF.request(request).responseData { response in
//            switch response.result {
//            case .success(let result):
//                print("\n\nPOST SUCCESS")
//
//                let decoder = JSONDecoder()
//                do {
//                    let product = try decoder.decode(APIResponse.self, from: result)
//                    completion(.success(product))
//
//                } catch {
//                    print(error)
//                    completion(.failure(error))
//                }
//
//
//            case .failure(let error):
//                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
//                completion(.failure(error))
//            }
//        }
//    }
//}
