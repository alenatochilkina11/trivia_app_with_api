//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

struct TriviaAPIResponse: Decodable {
  let triviaQuestions: [TriviaQuestion]

  private enum CodingKeys: String, CodingKey {
    case triviaQuestions = "results"
  }
}

class TriviaQuestionService {
    static func fetchTriviaQuestions(completion: (([TriviaQuestion]) -> Void)? = nil) {
        
        let url = URL(string: "https://opentdb.com/api.php?amount=10")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // this closure is fired when the response is received
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            // at this point, `data` contains the data received from the response
            let decoder = JSONDecoder()
            let response = try! decoder.decode(TriviaAPIResponse.self, from: data)
            DispatchQueue.main.async {
                print("trivia questions: \(response.triviaQuestions)")
                completion?(response.triviaQuestions)
            }
        }
        task.resume() // resume the task and fire the request
    }
}


