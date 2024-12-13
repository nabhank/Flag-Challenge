//
//  FlagChallengeModel.swift
//  Flags Challenge Demo
//
//  Created by Nabhan K on 11/12/24.
//

import Foundation
import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var hoursTens: String = "0"
    @Published var hoursUnits: String = "0"
    @Published var minutesTens: String = "0"
    @Published var minutesUnits: String = "0"
    @Published var secondsTens: String = "0"
    @Published var secondsUnits: String = "0"
    
    @Published var isTimerActive = false
    
    @Published var isStartTimerActive = false
    @Published var isChallegeStarted = false
    @Published var currentQuestion: Question?
    @Published var QuestionNo = 0
    @Published var isCoolOffTime = false
    @Published var isGameOver = false
    @Published var showScore = false
    
    var isAnswerCorrect:Bool?
    var score = 0
    var userAnswerId = 0
    private var countdownTimer: Timer?
    private var remainingTime: Int = 0
    private var questionsArray = [Question]()
    
    private var questionTime = 5
    private var coolOffTime = 2

    init() {
        // Check if there's an active timer on app launch
        self.questionsArray = self.loadQuestions()
        self.score = UserDefaults.standard.object(forKey: "answeredQuestions")  as? Int ?? 0
        checkForActiveTimer()
        
    }
    
    // Check if the timer is active when the app is restarted
    private func checkForActiveTimer() {
        if let endTime = UserDefaults.standard.object(forKey: "timerEndTime") as? Date {
            let currentTime = Date()
            let remainingTime = Int(endTime.timeIntervalSince(currentTime))
            
            if remainingTime > 0 {
                // Timer is still active, start it
                self.remainingTime = remainingTime
                self.isTimerActive = true
                startTimer(duration: remainingTime, timerType: .main)
               }
                else {
                if self.getShownQuestions().count > 0{
                    if let currentQuestion = getRandomQuestion(){
                        self.isStartTimerActive = false
                        self.isChallegeStarted = true
                        self.currentQuestion = currentQuestion
                        self.startTimer(hours: 0, minutes: 0, seconds: questionTime, timerType: .question)
                    }else{
                        self.gameOver()
                        
                    }
                    
                    return
                }
                //resetTimer(timerType: .main)
            }
        }else{
            if self.getShownQuestions().count > 0{
                if let currentQuestion = getRandomQuestion(){
                    self.isStartTimerActive = false
                    self.isChallegeStarted = true
                    self.currentQuestion = currentQuestion
                    self.startTimer(hours: 0, minutes: 0, seconds: questionTime, timerType: .question)
                }else{
                    self.gameOver()
                }
                return
            }
        }
    }

    // Start the timer with a given duration
    func startTimer(duration: Int,timerType:TimerType) {
        if timerType == .main{
            let currentTime = Date()
            let endTime = currentTime.addingTimeInterval(TimeInterval(duration))
            
            // Save the end time in UserDefaults
            UserDefaults.standard.set(endTime, forKey: "timerEndTime")
            UserDefaults.standard.set(duration, forKey: "timerDuration")
            UserDefaults.standard.synchronize()
        }
        
        
        self.isTimerActive = true
        self.remainingTime = duration
        
       
        updateTextFields(timerType: timerType)
      
        
        
        // Start the countdown
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateRemainingTime(timerType: timerType)
        }
    }

    // Update the remaining time
    private func updateRemainingTime(timerType:TimerType) {
        self.remainingTime -= 1
        
        if timerType == .main{
            if remainingTime <= 20{
                self.isStartTimerActive = true
            }
        }
        
        
        if remainingTime <= 0 {
            resetTimer(timerType: timerType)
            return
        }
        
        // Update text fields with the remaining time
        updateTextFields(timerType: timerType)
    }
    
    // Update the text fields based on remaining time
    private func updateTextFields(timerType:TimerType) {
        
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        
        switch timerType{
        case .main:
            // Update the text fields for hours, minutes, and seconds
            hoursTens = "\(hours / 10)"
            hoursUnits = "\(hours % 10)"
            minutesTens = "\(minutes / 10)"
            minutesUnits = "\(minutes % 10)"
            secondsTens = "\(seconds / 10)"
            secondsUnits = "\(seconds % 10)"
        case .coolOffTime:
            secondsTens = "\(seconds / 10)"
            secondsUnits = "\(seconds % 10)"
        case .question:
            secondsTens = "\(seconds / 10)"
            secondsUnits = "\(seconds % 10)"
        }
       
        
        
    }
    
    // Reset the timer
    func resetTimer(timerType:TimerType) {
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        switch timerType{
        case .main:
            UserDefaults.standard.removeObject(forKey: "timerEndTime")
            UserDefaults.standard.removeObject(forKey: "timerDuration")
            
            // Reset the UI to 0
            hoursTens = "0"
            hoursUnits = "0"
            minutesTens = "0"
            minutesUnits = "0"
            self.isStartTimerActive = false
            self.isChallegeStarted = true
            self.currentQuestion = getRandomQuestion()
            self.startTimer(hours: 0, minutes: 0, seconds: questionTime, timerType: .question)
        case .coolOffTime:
            secondsTens = "0"
            secondsUnits = "0"
            isCoolOffTime = false
            if let currentQuestion = getRandomQuestion(){
                self.userAnswerId = 0  //default value
                self.isAnswerCorrect = Bool() // default value
                self.currentQuestion = currentQuestion
                self.startTimer(hours: 0, minutes: 0, seconds: questionTime, timerType: .question)
            }else{
                self.gameOver()
            }
            
        case .question:
            secondsTens = "0"
            secondsUnits = "0"
            self.isCoolOffTime = true
            self.isAnswerCorrect = userAnswerId == self.currentQuestion?.id ? true : false
            self.score = self.isAnswerCorrect ?? false ? self.score + 1 : self.score
            self.saveCorrectAnswer()
            self.startTimer(hours: 0, minutes: 0, seconds: coolOffTime, timerType: .coolOffTime)
        }
        
       
        
        //self.isTimerActive = false
        //self.remainingTime = 0
    }
    
    // Handle save button click to start timer if valid
    func startTimer(hours: Int, minutes: Int, seconds: Int,timerType:TimerType) {
        let totalTimeInSeconds = hours * 3600 + minutes * 60 + seconds
        print(totalTimeInSeconds)
        if timerType == .main{
            if totalTimeInSeconds <= 20 {
                print("Time must be greater than 20 seconds")
                return
            }
        }
        
        
        startTimer(duration: totalTimeInSeconds, timerType: timerType)
    }
    
    
    
    func loadQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            fatalError("File not found: questions.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(QuestionResponse.self, from: data)
            return response.questions
        } catch {
            fatalError("Failed to decode JSON: \(error)")
        }
    }
    
    func getRandomQuestion() -> Question? {
       
        let shownIds = Set(getShownQuestions())
        
        let unseenQuestions = questionsArray.filter { !shownIds.contains($0.id) }
        
        
        guard let randomQuestion = unseenQuestions.randomElement() else {
            return nil // No unseen questions left
        }
        self.QuestionNo = shownIds.count + 1
        saveShownQuestion(randomQuestion.id)
        return randomQuestion
    }
    
    
    func saveShownQuestion(_ questionId: Int) {
        var shownQuestions = getShownQuestions()
        shownQuestions.append(questionId)
        UserDefaults.standard.set(shownQuestions, forKey: "shownQuestions")
    }
    
    func saveCorrectAnswer() {
        UserDefaults.standard.set(score, forKey: "answeredQuestions")
    }
    
    func resetAll() {
        UserDefaults.standard.removeObject(forKey: "shownQuestions")
        UserDefaults.standard.removeObject(forKey: "answeredQuestions")
        self.isStartTimerActive = false
        self.isChallegeStarted = false
        self.QuestionNo = 0
        self.isCoolOffTime = false
        self.isGameOver = false
        self.showScore = false
    }
    
    func getShownQuestions() -> [Int] {
        return UserDefaults.standard.array(forKey: "shownQuestions") as? [Int] ?? []
    }
    
    func gameOver(){
        self.isGameOver = true
        self.isChallegeStarted = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.isGameOver = false
            self.showScore = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.resetAll()
            }
            
        }
    }
    
    
    enum TimerType{
        case main
        case coolOffTime
        case question
    }
    
    
}
