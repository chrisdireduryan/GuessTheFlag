//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chris Direduryan on 22.11.2020.
//

import SwiftUI

struct FlagImage:View {
    var image: String

    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct CountryTitle:View {
    var country: String
    
    var body: some View {
        Text(country)
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.black)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var score = "0"
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""

    func flagTapped(_ number: Int) {
        var intScore = Int(score) ?? 0
        if number == correctAnswer {
            scoreTitle = "Correct"
            intScore += 1
            score = String(intScore)
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            intScore -= 1
            score = String(intScore)
            scoreMessage = "Wrong! That’s the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    CountryTitle(country: countries[correctAnswer])
                    Text("Your Score is: \(score)")
                        .foregroundColor(.white)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(image: self.countries[number])
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
