import SwiftUI



class CorrectnessMap: ObservableObject {
    @Published var correctnessMap = [false, false, false, false, false, false]
}

struct GameTrainView : View {
    
    @State var showCredit = false
    @ObservedObject var progressTracker = CorrectnessTracker()
    @State var score = 0
    @State var letterNum = Int.random(in: 0..<BrailleMap.letters.count)
    @State var showErrButton = false
    @ObservedObject var correctnessMap = CorrectnessMap()
    @State var showAlp = false
    

    @Binding var sounds: Bool
    @Binding var haptics: Bool
    @Binding var colorblind: Bool
    
    @State var showScore = false
    @State var showHint = false
    @Binding var upscaleCard: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                Text("Create the letter \(BrailleMap.letters[letterNum])")
                    .font(.title)
                .accessibilityLabel("Game instruction: use the braille card to create the letter \(BrailleMap.letters[letterNum])")
                .padding()
                .multilineTextAlignment(.center)
                
                Spacer()
                
                BrailleInterWrapper(progressTracker: self.progressTracker, correctnessMap: correctnessMap, sounds: $sounds, haptics: $haptics, colorblind: $colorblind, letter: letterNum)
                    .fixedSize()
                    .scaleEffect((UIDevice.current.localizedModel != "iPhone" && upscaleCard) ? 2 : 1)
                
                Spacer()
                
                
                
                
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        if sounds {
                            MusicPlayer.getInstance().playSound(.click)
                        }
                        showAlp = true
                    }, label: {
                        Image(systemName: "character.book.closed.fill")
                            .foregroundStyle(.white)
                            .font(.title3)
                            .padding([.top, .bottom], 15)
                        
                    }).background(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 80)
                            .foregroundStyle(.purple)
                            .frame(minWidth: 80, maxWidth: 100, minHeight: 40, idealHeight: 50, maxHeight: 100)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .frame(width: 80)
                    )
                    .shadow(radius: 5, x: 2, y: 2)
                    
                    .sheet(isPresented: $showAlp) {
                        NavigationStack {
                            AlphabetView(colorblind: $colorblind)
                                .toolbar {
                                    ToolbarItem(placement: .navigation) {
                                        Button(action: {
                                            showAlp = false
                                        }, label: {
                                            Text("Done")
                                                .fontWeight(.bold)
                                        })
                                    }
                                }
                        }
                        
                    }
                    Spacer()
                    Button(action: {
                        if sounds {
                            MusicPlayer.getInstance().playSound(.click)
                        }
                        showHint = true
                    }, label: {
                        if #available(iOS 17.0, *) {
                            Image(systemName: "lightbulb.max.fill")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .padding([.top, .bottom], 13)
                        } else {
                           Image(systemName: "questionmark.square.fill")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .padding([.top, .bottom], 17)
                        }
                        
                    }).background(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 80)
                            .foregroundStyle(.yellow)
                            .frame(minWidth: 80, maxWidth: 100, minHeight: 35, idealHeight: 50, maxHeight: 100)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .frame(width: 80)
                            .frame(minWidth: 80, maxWidth: 100, minHeight: 35, idealHeight: 50, maxHeight: 100)
                    )
                    .alert("💡Hint: Tap \(BrailleMap.map[BrailleMap.letters[letterNum]]!.count) bubble(s).", isPresented: $showHint) {
                        Button("OK", role: .cancel) { }
                    }
                    .shadow(radius: 5, x: 2, y: 2)
                    Spacer()
                    
                    
                    Button(action: {
                        if sounds {
                            MusicPlayer.getInstance().playSound(.click)
                        }
                        showScore = true
                    }, label: {
                        
                        Image(systemName: "dice.fill")
                            .foregroundStyle(.white)
                            .font(.title3)
                            .padding([.top, .bottom], 15)
                        
                        
                    }).background(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 80)
                            .foregroundStyle(.pink)
                            .frame(minWidth: 80, maxWidth: 100, minHeight: 40, idealHeight: 50, maxHeight: 100)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .frame(width: 80)
                    )
                    .alert("🎲 Your session score is \(score)", isPresented: $showScore) {
                        Button("OK", role: .cancel) { }
                    }
                    .shadow(radius: 5, x: 2, y: 2)
                    Spacer()
                    
                }
                .padding(.bottom)
                
                
            }
            
            
            
            
            if progressTracker.misClicked {
                ZStack {
                    Color.red.opacity(0.4).ignoresSafeArea()
                    VStack {
                        Image(systemName: "multiply.circle")
                            .font(.system(size:50))
                            .padding()
                            .accessibilityLabel("Icon indicating mistake.")
                        Text("That's not quite right.")
                            .font(.title)
                            .padding()
                        Button(action: {
                            if sounds {
                                MusicPlayer.getInstance().playSound(.click)
                            }
                            progressTracker.misClicked = false
                        }, label: {
                            Text("Try Again")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .frame(width: 250)
                                .padding()
                            
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 250)
                                .foregroundStyle(.red)
                            
                        )
                        
                        
                    }
                }
                .onAppear() {
                    if sounds {
                        MusicPlayer.getInstance().playSound(.wrong)
                    }
                }
                .background(.regularMaterial)
                .transition(
                    AnyTransition.asymmetric(
                        insertion: AnyTransition.opacity.animation(Animation.default.delay(0.01)),
                        removal: AnyTransition.opacity)
                )
                
            }
            
            if progressTracker.isCorrectFinished {
                ZStack {
                    Color.green.opacity(0.4).ignoresSafeArea()
                        .onAppear() {
                            if sounds {
                                MusicPlayer.getInstance().playSound(.correct)
                            }
                        }
                    VStack {
                        Image(systemName: "checkmark")
                            .font(.system(size:50))
                            .padding()
                            .accessibilityLabel("Checkmark for correctness.")
                        Text("Very good! Let's continue.")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding()
                        Button(action: {
                            if sounds {
                                MusicPlayer.getInstance().playSound(.click)
                            }
                            progressTracker.isCorrectFinished = false
                            progressTracker.misClicked = false
                            letterNum = Int.random(in: 0..<BrailleMap.letters.count)
                            correctnessMap.correctnessMap = [false, false, false, false, false, false]
                            score += 1
                        }, label: {
                            Text("Keep Playing")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .frame(width: 250)
                                .padding()
                            
                            
                        }).background(
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 250)
                                .foregroundStyle(.green)
                            
                        )
                        
                    }
                }
                .background(.regularMaterial)
                .transition(
                    AnyTransition.asymmetric(
                        insertion: AnyTransition.opacity.animation(Animation.default.delay(0.01)),
                        removal: AnyTransition.opacity)
                )
            }
            
            
            
            
        }

    }
    
}
