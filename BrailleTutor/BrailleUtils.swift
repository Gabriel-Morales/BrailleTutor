import SwiftUI

struct BrailleMap {
    static let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let map = ["a" : [0], "b" : [0,2], "c" : [0,1], "d" : [0,1,3], "e" : [0, 3], "f" : [0,1,2], "g" : [0,1,2,3], "h" : [0,2,3], "i" : [1, 2], "j" : [1,2,3], "k" : [0,4], "l" : [0,2,4], "m" : [0,1,4], "n" : [0,1,3,4], "o" : [0, 3, 4], "p" : [0,1,2,4], "q" : [0,1,2,3,4], "r" : [0,2,3,4], "s" : [1,2,4], "t" : [1,2,3,4], "u" : [0,4,5], "v" : [0,2,4,5], "w" : [1,2,3,5], "x" : [0,1,4,5], "y" : [0,1,3,4,5], "z" : [0,3,4,5]]
}

class CorrectnessTracker: ObservableObject {
    @Published var isCorrectFinished = false // triggers score? and triggers green light and reset
    @Published var misClicked = false // triggers "Wrong" view
    
    public func resetFinished() -> Void {
        self.isCorrectFinished = false
    }
    
    public func resetMisclick() -> Void {
        self.misClicked = false
    }
    
}

@available(iOS 17.0, *)
struct BrailleBoxInteractive: View {
    
    @ObservedObject var progressTracker: CorrectnessTracker
    @State var letter: Int = -1
    var lights: [Int]?
    @ObservedObject var correctnessMap: CorrectnessMap
    @State var bubbleCount = 0
    
    @Binding var sounds: Bool
    @Binding var haptics: Bool
    @Binding var colorblind: Bool
    @Environment(\.colorScheme) var col
    
    init(progressTracker: CorrectnessTracker, letter: Int, map: CorrectnessMap, sounds: Binding<Bool>, haptics: Binding<Bool>, colorblind: Binding<Bool>) {
        
        
        let letterString = BrailleMap.letters[letter]
        lights = BrailleMap.map[letterString]!
        self.progressTracker = progressTracker
        self.correctnessMap = map
        
        
        self._sounds = sounds
        self._haptics = haptics
        self._colorblind = colorblind
        self.letter = letter
 
    }
    
    var body: some View {
        
        Grid(horizontalSpacing: 25) {
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card top third left corner")
                    .accessibilityValue((correctnessMap.correctnessMap[0]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[0]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(0) {
                            correctnessMap.correctnessMap[0] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[0] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
                    

                Circle()
                    .accessibilityLabel("Braille Card top third right corner")
                    .accessibilityValue((correctnessMap.correctnessMap[1]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[1]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(1) {
                            correctnessMap.correctnessMap[1] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[1] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

            }
            
            
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card middle third. Left bubble")
                    .accessibilityValue((correctnessMap.correctnessMap[2]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[2]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(2) {
                            correctnessMap.correctnessMap[2] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[2] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                
                Circle()
                    .accessibilityLabel("Braille Card middle third. Right bubble")
                    .accessibilityValue((correctnessMap.correctnessMap[3]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[3]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(3) {
                            correctnessMap.correctnessMap[3] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[3] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

            }
            
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card Bottom Third. Left Corner.")
                    .accessibilityValue((correctnessMap.correctnessMap[4]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[4]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(4) {
                            correctnessMap.correctnessMap[4] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[4] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                Circle()
                    .accessibilityLabel("Braille Card Bottom Third. Right Corner.")
                    .accessibilityValue((correctnessMap.correctnessMap[5]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[5]) ? .cyan : ((col == .light) ? .white : .black))
                    .foregroundStyle(.cyan)
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(5) {
                            correctnessMap.correctnessMap[5] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                            
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[5] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
            }
        }
        .onChange(of: bubbleCount) { old, new in
            if new >= lights!.count {
                progressTracker.isCorrectFinished = true
                bubbleCount = 0
            }
        }
        .padding()
        

    }

}

@available(iOS 16.4, *)
struct BrailleBoxInteractiveOld: View {
    @Environment(\.colorScheme) var col
    @ObservedObject var progressTracker: CorrectnessTracker
    @State var letter: Int = -1
    var lights: [Int]?
    @ObservedObject var correctnessMap: CorrectnessMap
    @State var bubbleCount = 0
    
    
    @Binding var sounds: Bool
    @Binding var haptics: Bool
    @Binding var colorblind: Bool
    
   
    
    init(progressTracker: CorrectnessTracker, letter: Int, map: CorrectnessMap, sounds: Binding<Bool>, haptics: Binding<Bool>, colorblind: Binding<Bool>) {
        
        let letterString = BrailleMap.letters[letter]
        lights = BrailleMap.map[letterString]!
       
        self.correctnessMap = map
        
        self._sounds = sounds
        self._haptics = haptics
        self._colorblind = colorblind
        
        self.progressTracker = progressTracker
        self.letter = letter
    }
    
    var body: some View {
        
        Grid(horizontalSpacing: 25) {
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card top third left corner")
                    .accessibilityValue((correctnessMap.correctnessMap[0]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[0]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(0) {
                            correctnessMap.correctnessMap[0] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[0] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                Circle()
                    .accessibilityLabel("Braille Card top third right corner")
                    .accessibilityValue((correctnessMap.correctnessMap[1]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[1]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(1) {
                            correctnessMap.correctnessMap[1] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[0] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

            }
            
            
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card middle third. Left bubble")
                    .accessibilityValue((correctnessMap.correctnessMap[2]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[2]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(2) {
                            correctnessMap.correctnessMap[2] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[2] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                
                Circle()
                    .accessibilityLabel("Braille Card middle third. Right bubble")
                    .accessibilityValue((correctnessMap.correctnessMap[3]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[3]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(3) {
                            correctnessMap.correctnessMap[3] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[0] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

            }
            
            GridRow {
                Circle()
                    .accessibilityLabel("Braille Card Bottom Third. Left Corner.")
                    .accessibilityValue((correctnessMap.correctnessMap[4]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[4]) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(4) {
                            correctnessMap.correctnessMap[4] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[4] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                Circle()
                    .accessibilityLabel("Braille Card Bottom Third. Right Corner.")
                    .accessibilityValue((correctnessMap.correctnessMap[5]) ? "selected" : "not selected")
                    .foregroundStyle((correctnessMap.correctnessMap[5]) ? .cyan : ((col == .light) ? .white : .black))
                    .foregroundStyle(.cyan)
                    .frame(width: 50)
                    .padding()
                    .onTapGesture {
                        if self.haptics {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if lights!.contains(5) {
                            correctnessMap.correctnessMap[5] = true
                            bubbleCount += 1
                        } else {
                            progressTracker.misClicked = true
                            
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 70))
                            .opacity((correctnessMap.correctnessMap[5] && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
            }
        }
        .onChange(of: bubbleCount, perform: { value in
            if bubbleCount >= lights!.count {
                progressTracker.isCorrectFinished = true
                bubbleCount = 0
            }
        })
        .padding()
    }

}


struct BrailleInterWrapper: View {
    @ObservedObject var progressTracker: CorrectnessTracker
    @ObservedObject var correctnessMap: CorrectnessMap
    
    @Binding var sounds: Bool
    @Binding var haptics: Bool
    @Binding var colorblind: Bool
    
    @Environment(\.colorScheme) var col
    var letter: Int
    var body: some View {
        
        if #available(iOS 17.0, *) {
            BrailleBoxInteractive(progressTracker: self.progressTracker, letter: self.letter, map: self.correctnessMap, sounds: $sounds, haptics: $haptics, colorblind: $colorblind)
                .frame(width: 230)
                .background(.cyan.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 2)
                        .foregroundStyle(.cyan)
                )

        } else {
            BrailleBoxInteractiveOld(progressTracker: self.progressTracker, letter: self.letter, map: self.correctnessMap, sounds: $sounds, haptics: $haptics, colorblind: $colorblind)
                .frame(width: 230)
                .background(.cyan.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 2)
                        .foregroundStyle(.cyan)
                    )

        }
            
        
    }
    
    
    
}



struct BrailleBox: View {
    
    var letter: Int
    var lights: [Int]?
    
    @Environment(\.colorScheme) var col
    
    init(letter: Int) {
        self.letter = letter
        let letterString = BrailleMap.letters[letter]
        lights = BrailleMap.map[letterString]!
        
    }
    
    var body: some View {
        Grid(horizontalSpacing: 25) {
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(0)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                Circle()
                    .foregroundStyle((lights!.contains(1)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
            }
            
            
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(2)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                
                Circle()
                    .foregroundStyle((lights!.contains(3)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
            }
            
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(4)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
                Circle()
                    .foregroundStyle((lights!.contains(5)) ? .cyan : ((col == .light) ? .white : .black))
                    .foregroundStyle(.cyan)
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 50)
                    }
            }
        }
        
        .padding()
    }
}

struct BrailleBoxAlph: View {
    
    var letter: Int
    var lights: [Int]?
    
    let mainString: String
    
    @Binding var colorblind: Bool
    
    @Environment(\.colorScheme) var col
    
    init(letter: Int, colorblind: Binding<Bool>) {
        self.letter = letter
        let letterString = BrailleMap.letters[letter]
        lights = BrailleMap.map[letterString]!
        self.mainString =  "Braille card for '\(BrailleMap.letters[letter])'."
        
        self._colorblind = colorblind
        
    }
    
    var body: some View {
        Grid() {
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(0)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(0) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
                    
                Circle()
                    .foregroundStyle((lights!.contains(1)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(1) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
            }
            
            
            
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(2)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(2) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
                
                Circle()
                    .foregroundStyle((lights!.contains(3)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(3) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
            }
            
            
            GridRow {
                Circle()
                    .foregroundStyle((lights!.contains(4)) ? .cyan : ((col == .light) ? .white : .black))
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(4) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }

                Circle()
                    .foregroundStyle((lights!.contains(5)) ? .cyan : ((col == .light) ? .white : .black))
                    .foregroundStyle(.cyan)
                    .frame(width: 50)
                    .padding()
                    .overlay {
                        Circle()
                            .stroke()
                            .frame(width: 30)
                    }
                    .overlay {
                        Image(systemName: "checkmark.seal.fill")
                            .fontWeight(.bold)
                            .font(.system(size: 40))
                            .opacity((lights!.contains(5) && colorblind) ? 1.0 : 0.0)
                            .accessibilityHidden(true)
                    }
            }
            
        }
        .accessibilityElement()
        .accessibilityLabel(self.getLabelForLetter())
    }
    
    func getLabelForLetter() -> String {
        switch BrailleMap.letters[letter].lowercased() {
        case "a":
            return "\(self.mainString). Top left corner filled in. "
        case "b":
            return "\(self.mainString). Top left corner and middle left bubbles filled in."
        case "c":
            return "\(self.mainString). Top left corner and top right corner bubbles filled in. "
        case "d":
            return "\(self.mainString). Top left corner, top right corner, and middle right bubbles filled in."
        case "e":
            return "\(self.mainString). Top left corner and middle right bubbles filled in. "
        case "f":
            return "\(self.mainString). Top left corner, top right corner, and middle left bubbles filled in."
        case "g":
            return "\(self.mainString). First four bubbles filled in."
        case "h":
            return "\(self.mainString). Top left corner, middle left and middle right bubbles filled in."
        case "i":
            return "\(self.mainString). Top right corner and middle left bubbles filled in."
        case "j":
            return "\(self.mainString). Top right corner and middle two bubbles filled in."
        case "k":
            return "\(self.mainString). Top left corner and bottom left corner bubbles filled in."
        case "l":
            return "\(self.mainString). First column of bubbles filled in."
        case "m":
            return "\(self.mainString). Top row and bottom left corner bubbles filled in."
        case "n":
            return "\(self.mainString). Top row, middle right, and bottom left corner bubbles filled in."
        case "o":
            return "\(self.mainString). Top left corner, bottom left corner, and middle right bubbles filled in."
        case "p":
            return "\(self.mainString). Top row, middle left, and bottom left corner bubbles filled in."
        case "q":
            return "\(self.mainString). First four bubbles and bottom left corner filled in."
        case "r":
            return "\(self.mainString). First column and middle right bubbles filled in."
        case "s":
            return "\(self.mainString).  Top right corner, middle left and bottom left corner bubbles filled in."
        case "t":
            return "\(self.mainString).  Top right corner, middle row, and bottom left corner bubbles filled in."
        case "u":
            return "\(self.mainString). Top left corner and bottom row bubbless filled in."
        case "v":
            return "\(self.mainString). First column and bottom right corner bubbles filled in."
        case "w":
            return "\(self.mainString). Middle left and second column bubbles filled in."
        case "x":
            return "\(self.mainString).  Top row and bottom row bubbles filled in."
        case "y":
            return "\(self.mainString). Top row, middle right, and bottom row bubbles filled in."
        default:
            return "\(self.mainString). Top left corner, middle right bubble, and bottom row bubbles filled in."
        }
    }
    
    
}


struct BrailleRegularWrapper: View {
    @State var letterNum: Int
    @Binding var colorblind: Bool
    
    var body: some View {
        
            BrailleBoxAlph(letter: letterNum, colorblind: $colorblind)
                .frame(width: 145, height: 200)
                .background(.cyan.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
                        .foregroundStyle(.cyan)
                )
   
    }
}


struct AlphabetView: View {
    let columns1 = [GridItem(.flexible()), GridItem(.flexible())]
    
    @Binding var colorblind: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns1, spacing: 80) {
                ForEach(0..<BrailleMap.letters.count) { num in
                    VStack {
                        BrailleRegularWrapper(letterNum: num, colorblind: $colorblind)
                            .padding()
                        Text("Letter: \(BrailleMap.letters[num])")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                }
            }.padding()
        }
        
    }
}





struct BrailleAnimWrapper: View {

    var body: some View {
        TimelineView(.animation) { ctx in
            BrailleBox(letter: Int(ctx.date.timeIntervalSince1970) % BrailleMap.letters.count)
                .frame(width: 230)
                .background(.cyan.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 2)
                        .foregroundStyle(.cyan)
                )
            
        }
    }
}
