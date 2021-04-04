//
//  CreateMeetingRoomAPI.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/25.
//

import Foundation
import Alamofire

class CreateMeetingRoomAPI {
    
    static let shared = CreateMeetingRoomAPI()
    
    private init() {}
    
    func post(paramArray: Array<UITextField>, completion: @escaping (Result<CreateMeetingRoomAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/checkStatus"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10

        //POST로 보낼 정보
        let params = ["participants" : paramArray[0].text!,
                      "openkakaotalk" : paramArray[1].text!] as Dictionary

        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }

        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\nPOST SUCCESS")

                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(CreateMeetingRoomAPIResponse.self, from: result)
                    completion(.success(product))

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