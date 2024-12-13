//
//  ContentView.swift
//  Flags Challenge Demo
//
//  Created by Nabhan K on 11/12/24.
//

import SwiftUI

struct FlagChallengeView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    // Focus state for text fields
        @FocusState private var focusedField: Field?

        // Enum to manage focus order
        enum Field: Hashable {
            case hourTens, hourUnits, minuteTens, minuteUnits, secondTens, secondUnits
        }
    
    var body: some View {
        VStack {
            ZStack{
                HStack{
                    Text(viewModel.isChallegeStarted ? "00:\(viewModel.secondsTens + viewModel.secondsUnits)" : "00:00" )
                        .padding(10)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    Spacer()
                }
                Text("FLAGS CHALLENGE")
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
            }
            
            if viewModel.isStartTimerActive{
               startChallengeView
                
            }else if viewModel.isChallegeStarted{
                
                questionsView
                    
                
            }else if viewModel.isGameOver{
                self.gameOverView
            }else if viewModel.showScore{
                self.scoreView
            }
            else{
               mainTimerView
            }
            
            
            
            
        }
        .onChange(of: viewModel.isTimerActive) {
                    if !viewModel.isTimerActive {
                        // Reset the text fields when timer is reset
                        resetTextFields()
                    }
        }
        .background(Color(hex: "D9D9D9").opacity(0.3))
        .cornerRadius(5)
        .padding()
        Spacer()
    }
    
    private func handleTextFieldChange() {
            if viewModel.isTimerActive {
                return // Do not allow changes if the timer is active
            }
            
            // Validate input for text fields to ensure they meet the constraints
            validateTextFieldInput()
        }

        private func resetTextFields() {
            viewModel.hoursTens = "0"
            viewModel.hoursUnits = "0"
            viewModel.minutesTens = "0"
            viewModel.minutesUnits = "0"
            viewModel.secondsTens = "0"
            viewModel.secondsUnits = "0"
        }
    
    private func validateTextFieldInput() {
            // Add your validation logic here
        }
    private var mainTimerView:some View{
        Group{
            Text("Schedule")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(20)
            HStack(spacing:10){
                VStack{
                    Text("Hour")
                        .font(.system(size: 13))
                    HStack(spacing:3){
                        TextField("0", text: $viewModel.hoursTens)
                           // .onChange(of: viewModel.hoursTens) { validateHourTens($0) }
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .hourTens)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(viewModel.isTimerActive)
                            .onChange(of: viewModel.hoursTens) {
                                handleTextFieldChange()
                            }
                        TextField("0", text: $viewModel.hoursUnits)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(viewModel.isTimerActive)
                            .onChange(of: viewModel.hoursUnits) {
                                handleTextFieldChange()
                            }
                    }
                }
                VStack{
                    Text("Minute")
                        .font(.system(size: 13))
                    HStack(spacing:3){
                        TextField("0", text: $viewModel.minutesTens)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(viewModel.isTimerActive)
                            .onChange(of: viewModel.minutesTens) {
                                handleTextFieldChange()
                            }
                        TextField("0", text: $viewModel.minutesUnits)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(viewModel.isTimerActive)
                            .onChange(of: viewModel.minutesUnits) {
                                handleTextFieldChange()
                            }
                    }
                }
                VStack{
                    Text("Second")
                        .font(.system(size: 13))
                    HStack(spacing:3){
                        TextField("0", text: $viewModel.secondsTens)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(false)
                            .onChange(of: viewModel.secondsTens) {
                                handleTextFieldChange()
                            }
                        TextField("0", text: $viewModel.secondsUnits)
                            .background(Color(hex: "D9D9D9"))
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)
                            .cornerRadius(5)
                            .disabled(!viewModel.isTimerActive)
                            .onChange(of: viewModel.secondsUnits) {
                                handleTextFieldChange()
                            }
                    }
                }
            }
            .padding()
            Button(action: {
                if let hours = Int(viewModel.hoursTens + viewModel.hoursUnits),
                   let minutes = Int(viewModel.minutesTens + viewModel.minutesUnits),
                   let seconds = Int(viewModel.secondsTens + viewModel.secondsUnits) {
                    viewModel.startTimer(hours: hours, minutes: minutes, seconds: seconds,timerType: .main)
                }
            }, label: {
                Text("Save").padding(10)
                    .frame(width: 70)
                    .background(Color(hex: "FF7043"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    
            })
            .padding()
        }
    }
    private var startChallengeView:some View{
        Group{
            VStack(spacing:10){
                Text("CHALLENGE")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                   // .padding(20)
                Text("WILL START IN")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                   // .padding(20)
                Text("00:\(viewModel.secondsTens + viewModel.secondsUnits)")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .padding()
            }
        }
    }
    
    private var questionsView: some View{
        VStack{
            ZStack{
                HStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 40, height: 32)
                            .foregroundColor(Color.black)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        Text("\(viewModel.QuestionNo)")
                            .frame(width: 30,height: 30)
                            .background(Color(hex: "FF7043"))
                            .cornerRadius(15)
                    }
                    Spacer()
                }
                Text("Guess the country from the flag ?")
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                
                
                    
            }.padding(.bottom)
                .padding(.top)
            
            Group{
                
                HStack{
                    Image(viewModel.currentQuestion?.countryCode ?? "NZ")
                        .resizable()
                        .frame(width: 80,height: 60)
                        .padding()
                    VStack(spacing:5){
                        HStack{
                            VStack{
                                Button(action: {
                                    if !viewModel.isCoolOffTime{
                                        viewModel.userAnswerId = viewModel.currentQuestion?.countries[0].id ?? 0
                                    }
                                    
                                }, label: {
                                    Text(viewModel.currentQuestion?.countries[0].countryName ?? "Country Name")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .background((viewModel.userAnswerId == viewModel.currentQuestion?.countries[0].id ?? 0) ? Color(hex: "D9D9D9") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray, lineWidth: 1)  // Border color and width
                                        )
                                    
                                })
                                Text(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[0].id == viewModel.currentQuestion?.id)) ? "Correct" : "Wrong")
                                    .font(.system(size: 10))
                                    .fontWeight(.regular)
                                    .foregroundStyle(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[0].id == viewModel.currentQuestion?.id)) ? Color.green : Color(hex: "FF7043"))
                                    .opacity((viewModel.isCoolOffTime && ((viewModel.userAnswerId == viewModel.currentQuestion?.countries[0].id) || (viewModel.currentQuestion?.countries[0].id == viewModel.currentQuestion?.id)) ) ? 1 : 0)
                            }
                            VStack{
                                Button(action: {
                                    if !viewModel.isCoolOffTime{
                                        viewModel.userAnswerId = viewModel.currentQuestion?.countries[1].id ?? 0
                                    }
                                
                                    viewModel.userAnswerId = viewModel.currentQuestion?.countries[1].id ?? 0
                                }, label: {
                                    Text(viewModel.currentQuestion?.countries[1].countryName ?? "Country Name")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .background((viewModel.userAnswerId == viewModel.currentQuestion?.countries[1].id ?? 0) ? Color(hex: "D9D9D9") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray, lineWidth: 1)  // Border color and width
                                        )
                                        
                                })
                                
                                Text(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[1].id == viewModel.currentQuestion?.id)) ? "Correct" : "Wrong")
                                    .font(.system(size: 10))
                                    .fontWeight(.regular)
                                    .foregroundStyle(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[1].id == viewModel.currentQuestion?.id)) ? Color.green : Color(hex: "FF7043"))
                                    .opacity((viewModel.isCoolOffTime && ((viewModel.userAnswerId == viewModel.currentQuestion?.countries[1].id) || (viewModel.currentQuestion?.countries[1].id == viewModel.currentQuestion?.id)) ) ? 1 : 0)
                                    //.opacity((viewModel.isCoolOffTime ? 1 : 0))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        HStack{
                            VStack{
                                Button(action: {
                                    if !viewModel.isCoolOffTime{
                                        viewModel.userAnswerId = viewModel.currentQuestion?.countries[2].id ?? 0
                                    }
                                    viewModel.userAnswerId = viewModel.currentQuestion?.countries[2].id ?? 0
                                }, label: {
                                    Text(viewModel.currentQuestion?.countries[2].countryName ?? "Country Name")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .background((viewModel.userAnswerId == viewModel.currentQuestion?.countries[2].id ?? 0) ? Color(hex: "D9D9D9") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray, lineWidth: 1)  // Border color and width
                                        )
                                        
                                })
                                Text(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[2].id == viewModel.currentQuestion?.id)) ? "Correct" : "Wrong")
                                    .font(.system(size: 10))
                                    .fontWeight(.regular)
                                    .foregroundStyle(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[2].id == viewModel.currentQuestion?.id)) ? Color.green : Color(hex: "FF7043"))
                                    .opacity((viewModel.isCoolOffTime && ((viewModel.userAnswerId == viewModel.currentQuestion?.countries[2].id) || (viewModel.currentQuestion?.countries[2].id == viewModel.currentQuestion?.id)) ) ? 1 : 0)
                            }
                            VStack{
                                Button(action: {
                                    if !viewModel.isCoolOffTime{
                                        viewModel.userAnswerId = viewModel.currentQuestion?.countries[3].id ?? 0
                                    }
                                   
                                }, label: {
                                    Text(viewModel.currentQuestion?.countries[3].countryName ?? "Country Name")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .background((viewModel.userAnswerId == viewModel.currentQuestion?.countries[3].id ?? 0) ? Color(hex: "D9D9D9") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray, lineWidth: 1)  // Border color and width
                                        )
                                        
                                })
                                Text(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[3].id == viewModel.currentQuestion?.id)) ? "Correct" : "Wrong")
                                    .font(.system(size: 10))
                                    .fontWeight(.regular)
                                    .foregroundStyle(((viewModel.userAnswerId == viewModel.currentQuestion?.id ?? 0) || (viewModel.currentQuestion?.countries[3].id == viewModel.currentQuestion?.id)) ? Color.green : Color(hex: "FF7043"))
                                    .opacity((viewModel.isCoolOffTime && ((viewModel.userAnswerId == viewModel.currentQuestion?.countries[3].id) || (viewModel.currentQuestion?.countries[3].id == viewModel.currentQuestion?.id)) ) ? 1 : 0)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
            }
        }
        
    }
    
    
    private var gameOverView:some View{
        Text("GAME OVER")
            .font(.system(size: 35))
            .fontWeight(.semibold)
            .padding(20)
    }
    
    private var scoreView:some View{
        HStack{
            Spacer()
            Text("Score : ")
                .font(.system(size: 20))
                .fontWeight(.regular)
                .foregroundStyle(Color.red)
            Text("\(viewModel.score)/\(viewModel.loadQuestions().count)")
                .font(.system(size: 30))
                .fontWeight(.semibold)
            
            Spacer()
        }.padding([.bottom,.top],30)
        
    }
    
}

#Preview {
    FlagChallengeView()
}
