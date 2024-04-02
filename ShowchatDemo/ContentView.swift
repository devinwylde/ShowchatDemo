//
//  ContentView.swift
//  ShowchatDemo
//
//  Created by Devin Wylde on 3/29/24.
//

import SwiftUI

// follower protocol for rooms and users
protocol Follower: Identifiable {
    var id: UUID { get set }
    var displayName: String { get set }
    var pfp: Image { get set }
    var showsWatched: [UUID] { get set }
}

struct Room: Follower {
    var id: UUID
    var displayName: String
    var pfp: Image
    var showsWatched: [UUID]
    var ownerID: UUID
}

struct User: Follower {
    var id: UUID
    var displayName: String
    var pfp: Image
    var showsWatched: [UUID]
}

struct Show {
    static var byUUID: [UUID: Show] = [:]
    
    var id: UUID
    var poster: Image
}

// define sizes of elements based on screen size
struct Presets {
    static var vals = Presets()
    
    var unit: CGFloat
    var pfpWidth: CGFloat
    var fPfpWidth: CGFloat
    var buttonWidth: CGFloat
    var paddingWidth: CGFloat
    var removeImgWidth: CGFloat
    var sheetHeight: CGFloat
    var titleFontSize: CGFloat
    var lgFontSize: CGFloat
    var medFontSize: CGFloat
    var smFontSize: CGFloat
    var tidFontSize: CGFloat
    var fButtonSize: CGSize
    var cButtonSize: CGSize
    var pullTabSize: CGSize
    var posterSize: CGSize
    
    let defGradient = LinearGradient(colors: [Color(red: 1, green: 0.784, blue: 0.216), Color(red: 1, green: 0.682, blue: 0.149), Color(red: 1, green: 0.502, blue: 0.031)], startPoint: .leading, endPoint: .trailing)
    let darkGradient = Gradient(colors: [Color(red: 0.086, green: 0.129, blue: 0.145), Color(red: 0.133, green: 0.153, blue: 0.188)])
    let lightGray = Color(red: 0.624, green: 0.624, blue: 0.627)
    let darkGray = Color(red: 0.133, green: 0.137, blue: 0.141)
    let gray = Color(red: 0.153, green: 0.157, blue: 0.165)
    let orange = Color(red: 1, green: 0.533, blue: 0.106)
    
    // defaults
    init() {
        unit = 2
        pfpWidth = 80
        fPfpWidth = 48
        buttonWidth = 40
        paddingWidth = 12
        removeImgWidth = 10
        sheetHeight = 300
        titleFontSize = 32
        lgFontSize = 20
        medFontSize = 16
        smFontSize = 14
        tidFontSize = 12
        fButtonSize = CGSize(width: 115, height: 40)
        cButtonSize = CGSize(width: 340, height: 64)
        pullTabSize = CGSize(width: 44, height: 4)
        posterSize = CGSize(width: 66, height: 104)
    }

    static func update(screenSize: CGSize) {
        vals.unit = screenSize.width / 187.5
        update()
    }
    
    private static func update() {
        vals.pfpWidth = vals.unit * 40
        vals.fPfpWidth = vals.unit * 24
        vals.buttonWidth = vals.unit * 20
        vals.paddingWidth = vals.unit * 6
        vals.removeImgWidth = vals.unit * 5
        vals.sheetHeight = vals.unit * 150
        vals.titleFontSize = vals.unit * 16
        vals.lgFontSize = vals.unit * 10
        vals.medFontSize = vals.unit * 8
        vals.smFontSize = vals.unit * 7
        vals.tidFontSize = vals.unit * 6
        vals.fButtonSize = CGSize(width: vals.unit * 58, height: vals.unit * 20)
        vals.cButtonSize = CGSize(width: vals.unit * 170, height: vals.unit * 32)
        vals.pullTabSize = CGSize(width: vals.unit * 22, height: vals.unit * 2)
        vals.posterSize = CGSize(width: vals.unit * 33, height: vals.unit * 52)
    }
}

// main content view
struct ContentView: View {
    // state for search bar text
    @State private var searchText = ""
    
    // states for popup
    @State private var deletingRoom: Room? = nil
    @State private var removingFollower: User? = nil
    @State private var popup = false
    
    // user details
    private var uid: UUID
    private var username: String
    private var showchats: Int
    
    // followers
    @State private var roomFollowers: [Room]
    @State private var userFollowers: [User]
    // following
    @State private var following: [UUID]

    init() {
        // GENERATE TEST DATA
        uid = UUID()
        username = "ShowchatCat"
        showchats = 1323
        
        let d = [UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID()]
        Show.byUUID = [
            d[0]: Show(id: d[0], poster: Image("all-the-light-we-cannot-see")),
            d[1]: Show(id: d[1], poster: Image("beef")),
            d[2]: Show(id: d[2], poster: Image("indian_matchmaking")),
            d[3]: Show(id: d[3], poster: Image("love-is-blind")),
            d[4]: Show(id: d[4], poster: Image("love-island-2019")),
            d[5]: Show(id: d[5], poster: Image("queer-eye")),
            d[6]: Show(id: d[6], poster: Image("selling-sunset")),
            d[7]: Show(id: d[7], poster: Image("suits")),
            d[8]: Show(id: d[8], poster: Image("the-circle")),
            d[9]: Show(id: d[9], poster: Image("the-great-british-bake-off"))
        ]
        
        _roomFollowers = State(initialValue: [
            Room(id: UUID(), displayName: "Room LAcrew", pfp: Image("pfp1"), showsWatched: [d[1], d[5], d[7]], ownerID: uid),
            Room(id: UUID(), displayName: "Room NYgirls", pfp: Image("pfp2"),  showsWatched: [d[2], d[0], d[1]], ownerID: UUID())
        ])
        
        let userFollowing = UUID()
        _following = State(initialValue: [userFollowing])
        _userFollowers = State(initialValue: [
            User(id: userFollowing, displayName: "Kathryn Murphy", pfp: Image("pfp3"),  showsWatched: [d[2], d[3], d[4]]),
            User(id: UUID(), displayName: "Kristin Watson", pfp: Image("pfp4"),  showsWatched: [d[5], d[6], d[7]]),
            User(id: UUID(), displayName: "Leslie Alexander", pfp: Image("pfp5"),  showsWatched: [d[0], d[8], d[9]]),
            User(id: UUID(), displayName: "Eleanor Pena", pfp: Image("pfp6"),  showsWatched: [d[1]]),
            User(id: UUID(), displayName: "Annette Black", pfp: Image("pfp7"),  showsWatched: [])
        ])
    }
    
    // main view body
    var body: some View {
        // geometryreader (provide dimensions for presets)
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    // header
                    HeaderView(username: username, showchatCount: showchats, followerCount: roomFollowers.count + userFollowers.count, followingCount: following.count)
                    
                    // title
                    Text("MY FOLLOWERS")
                        .font(.custom("Montserrat", size: Presets.vals.lgFontSize))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal)
                    
                    // search bar
                    Rectangle()
                        .foregroundStyle(Presets.vals.gray)
                        .frame(height: 48)
                        .overlay(
                            HStack {
                                IconButton(image: Image(systemName: "magnifyingglass"))
                                    .foregroundStyle(Color.white)
                                    .padding(.leading, Presets.vals.paddingWidth / 2)
                                TextField("", text: $searchText)
                                // x dismisses keyboard and clears search
                                Image(systemName: "xmark")
                                    .foregroundStyle(Presets.vals.lightGray)
                                    .padding(.trailing, Presets.vals.paddingWidth)
                                    .onTapGesture {
                                        searchText = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                            }
                        )
                    
                    // follower list
                    List {
                        // rooms
                        ForEach(roomFollowers.filter { follower in
                            searchText.isEmpty || follower.displayName.localizedCaseInsensitiveContains(searchText)
                        }) { follower in
                            FollowerView(follower: follower, owner: follower.ownerID == uid, following: false, action: {
                                if follower.ownerID == uid {
                                    deletingRoom = follower
                                    popup.toggle()
                                } else {
                                    // FIREBASE CODE
                                    withAnimation {
                                        roomFollowers.removeAll { f in
                                            f.id == follower.id
                                        }
                                    }
                                }
                            })
                        }
                        
                        // users
                        ForEach(userFollowers.filter { follower in
                            searchText.isEmpty || follower.displayName.localizedCaseInsensitiveContains(searchText)
                        }) { follower in
                            FollowerView(follower: follower, owner: false, following: following.contains(follower.id), action: {
                                if following.contains(follower.id) {
                                    // ADD ACTION HERE
                                } else {
                                    // FIREBASE CODE
                                    following.append(follower.id)
                                }
                            })
                            .swipeActions(edge: .trailing) {
                                Button {
                                    removingFollower = follower
                                    popup.toggle()
                                } label: {
                                    Image("remove")
                                }
                                .tint(.clear)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                VStack {
                    Spacer()
                    Button("Create a room") {
                        // ADD FUNCTIONALITY HERE
                    }
                    .frame(width: Presets.vals.cButtonSize.width, height: Presets.vals.cButtonSize.height)
                    .background(Presets.vals.defGradient)
                    .cornerRadius(Presets.vals.cButtonSize.height / 3)
                    .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                    .foregroundStyle(Color.black)
                    .padding(.bottom, 20)
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(Color(red: 0.067, green: 0.071, blue: 0.078))
            .font(.custom("Montserrat", size: 16))
            // popup sheet for confirming and removing followers/rooms
            .sheet(isPresented: $popup, onDismiss: {
                removingFollower = nil
                deletingRoom = nil
            }) {
                ConfirmationPopup(
                    text: deletingRoom != nil ? "Deleting a room removes everyone from it." : "Once you remove a follower, they will need to request to follow again.",
                    buttonText: deletingRoom != nil ? "Yes, delete" : "Yes, remove",
                    action: popupAction, closeAction: { popup.toggle() })
                .presentationDetents([.height(Presets.vals.sheetHeight)])
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(30.0)
            }
            .onChange(of: geometry.size) {
                Presets.update(screenSize: geometry.size)
            }
        }
    }
    
    private func popupAction() {
        if deletingRoom != nil {
            deleteRoom()
        } else if removingFollower != nil {
            removeFollower()
        }
        
        popup.toggle()
    }
    
    private func deleteRoom() {
        guard deletingRoom?.ownerID == uid else {
            popup.toggle()
            return;
        }
        
        // FIREBASE CODE HERE
        withAnimation {
            roomFollowers.removeAll { follower in
                follower.id == deletingRoom?.id
            }
        }
    }
    
    private func removeFollower() {
        // FIREBASE CODE HERE
        withAnimation {
            userFollowers.removeAll { follower in
                follower.id == removingFollower?.id
            }
        }
    }
}

// header with user information
struct HeaderView: View {
    var username: String
    var showchatCount: Int
    var followerCount: Int
    var followingCount: Int
    
    var body: some View {
        HStack(alignment: .top) {
            Image("demoimg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Presets.vals.pfpWidth, height: Presets.vals.pfpWidth)
                .cornerRadius(Presets.vals.pfpWidth)
                .overlay(
                    RoundedRectangle(cornerRadius: Presets.vals.pfpWidth)
                        .stroke(Presets.vals.defGradient, lineWidth: 1)
                )
                .padding(1)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(username)
                        .font(.custom("Montserrat", size: Presets.vals.lgFontSize))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    Spacer()
                    IconButton(image: Image(systemName: "square.and.pencil"))
                        .foregroundStyle(Color.white)
                    IconButton(image: Image("icon_more"))
                }
                HStack {
                    InfoTile(count: showchatCount, name: "Showchats")
                    Spacer()
                    InfoTile(count: followerCount, name: "Followers")
                    Spacer()
                    InfoTile(count: followingCount, name: "Following")
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(4)
        }
        .padding(.horizontal)
    }
}

// icon in dark gray circle
struct IconButton: View {
    var image: Image
    
    var body: some View {
        RoundedRectangle(cornerRadius: Presets.vals.buttonWidth)
            .foregroundStyle(Presets.vals.darkGradient)
            .frame(width: Presets.vals.buttonWidth, height: Presets.vals.buttonWidth)
            .overlay(
                image
                    .resizable()
                    .frame(width: Presets.vals.buttonWidth / 1.8, height: Presets.vals.buttonWidth / 1.8)
            )
    }
}

// contains a count and name
struct InfoTile: View {
    var count: Int
    var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(count))
                .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                .foregroundStyle(Color.white)
            Text(name)
                .font(.custom("Montserrat", size: Presets.vals.tidFontSize))
                .foregroundStyle(Presets.vals.lightGray)
                .onTapGesture {
                }
        }
    }
}

// contains all follower information visible in a row
struct FollowerView: View {
    var follower: any Follower
    var owner: Bool
    var following: Bool
    var action: () -> Void
    
    @State var showsVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // user data
            HStack {
                // image
                follower.pfp
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Presets.vals.fPfpWidth, height: Presets.vals.fPfpWidth)
                    .cornerRadius(Presets.vals.fPfpWidth)
                    .overlay(
                        RoundedRectangle(cornerRadius: Presets.vals.fPfpWidth)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(1)
                    .clipped()
                
                // text
                VStack(alignment: .leading) {
                    Text(follower.displayName)
                        .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    Text(showsVisible ? "Hide watched shows" : "Show watched shows")
                        .font(.custom("Montserrat", size: Presets.vals.tidFontSize))
                        .foregroundStyle(Presets.vals.lightGray)
                        .onTapGesture {
                            showsVisible.toggle()
                        }
                }
                Spacer()
                
                // button
                let user = follower as? User != nil
                let text = owner ? "Delete room" : following ? "Following" : user ? "Follow back" : "Leave room"
                Button(text, action: action)
                    .modifier(FollowerButton(colorful: !following && user))
            }
            
            // shows
            if showsVisible {
                HStack {
                    ForEach(follower.showsWatched, id: \.self) { id in
                        Show.byUUID[id]!.poster
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Presets.vals.posterSize.width, height: Presets.vals.posterSize.height)
                            .padding(1)
                            .clipped()
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
    }
}

// modifiers for a button next to follower info
struct FollowerButton: ViewModifier {
    var colorful: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: Presets.vals.fButtonSize.width, height: Presets.vals.fButtonSize.height)
            .background(colorful ? Gradient(colors: [Color.clear]) : Presets.vals.darkGradient)
            .cornerRadius(Presets.vals.fButtonSize.height)
            .overlay(
                RoundedRectangle(cornerRadius: Presets.vals.fButtonSize.height)
                    .stroke(colorful ? Presets.vals.defGradient : LinearGradient(colors: [Presets.vals.gray], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
            )
            .font(.custom("Montserrat", size: Presets.vals.smFontSize))
            .foregroundStyle(colorful ? Presets.vals.orange : Presets.vals.lightGray)
    }
}

// confirms a user action
struct ConfirmationPopup: View {
    var text: String
    var buttonText: String
    var action: () -> Void
    var closeAction: () -> Void
    
    var body: some View {
        VStack(spacing: Presets.vals.paddingWidth) {
            RoundedRectangle(cornerRadius: Presets.vals.pullTabSize.height)
                .foregroundStyle(Presets.vals.lightGray)
                .frame(width: Presets.vals.pullTabSize.width, height: Presets.vals.pullTabSize.height)
            Text("Are you sure?")
                .font(.custom("Montserrat", size: Presets.vals.titleFontSize))
                .fontWeight(.bold)
            Text(text)
                .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                .multilineTextAlignment(.center)
            Button(buttonText, action: action)
                .frame(width: Presets.vals.cButtonSize.width, height: Presets.vals.cButtonSize.height)
                .background(Presets.vals.defGradient)
                .cornerRadius(Presets.vals.cButtonSize.height / 3)
                .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                .foregroundStyle(Color.black)
            Button("No, go back", action: closeAction)
                .frame(width: Presets.vals.cButtonSize.width, height: Presets.vals.cButtonSize.height)
                .background(Presets.vals.darkGradient)
                .cornerRadius(Presets.vals.cButtonSize.height / 3)
                .font(.custom("Montserrat", size: Presets.vals.medFontSize))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    ContentView()
}
