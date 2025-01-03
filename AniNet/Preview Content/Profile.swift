//
//  Profile.swift
//  AniNet
//
//  Created by Safiya May on 1/2/25.
//

import SwiftUI

struct Profile: View {
    @State private var username: String = "Adam"
    @State private var isEditingName: Bool = false // State to toggle editing mode
    @State private var profileImage: UIImage? // To store the selected image
    @State private var ringColor: Color = .yellow // Default ring color
    @State private var top3Images: [ImageItem] = [
        ImageItem(imageName: "blackClover"),
        ImageItem(imageName: "onePiece"),
        ImageItem(imageName: "yuyuHakusho")
    ]
    @State private var recentlyWatched: [ImageItem] = [
        ImageItem(imageName: "danDaDan"),
        ImageItem(imageName: "fireForce"),
        ImageItem(imageName: "bleach"),
        ImageItem(imageName: "loveIsWar")
    ]
    @State private var isImagePickerPresented: Bool = false
    @State private var isColorPickerPresented: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header Section
                HStack {
                    // Left Side: Profile Image and Username
                    VStack(alignment: .leading, spacing: 10) {
                        // Username (Editable)
                        if isEditingName {
                            TextField("Enter your name", text: $username, onCommit: {
                                isEditingName = false // End editing when the user presses return
                            })
                            .font(.system(size: 34, weight: .bold, design: .rounded)) // Updated font
                            .foregroundColor(.white)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.clear)
                            .onTapGesture {
                                isEditingName = true
                            }
                        } else {
                            Text(username)
                                .font(.system(size: 34, weight: .bold, design: .rounded)) // Updated font
                                .foregroundColor(.white)
                                .onTapGesture {
                                    isEditingName = true // Enter editing mode when tapped
                                }
                        }

                        // Profile Image
                        ZStack {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(ringColor, lineWidth: 5)
                                    )
                                    .shadow(radius: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Circle()
                                            .stroke(ringColor, lineWidth: 5)
                                    )
                                    .shadow(radius: 10)
                                    .overlay(
                                        Text("Add")
                                            .font(.system(size: 12, weight: .bold, design: .rounded)) // Updated font
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                    }
                    .offset(x: -10)

                    Spacer()

                    // Right Side: Watched, Following, Followers
                    HStack(spacing: 30) {
                        StatView(title: "watched", count: "30")
                        StatView(title: "following", count: "85")
                        StatView(title: "followers", count: "4790")
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .offset(y: 25)
                }
                .padding(.horizontal)



                VStack(alignment: .leading) {
                    HStack(spacing: 5) { // Added spacing
                        Text("My top 3")
                            .font(.system(size: 16, weight: .bold, design: .rounded)) // Updated font
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .offset(x: -125, y: 30)

                    ZStack {
                        // Third Image (backmost)
                        Image(top3Images[2].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Ensure the image fills the frame
                            .frame(width: 110, height: 170) // Uniform size for all images
                            .clipped() // Ensure no overflow
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2) // White border with opacity
                            )
                            .shadow(radius: 5)
                            .rotationEffect(Angle(degrees: 20)) // Rotate slightly
                            .offset(x: 105, y: 30) // Move to the right

                        // Second Image (middle)
                        Image(top3Images[1].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Ensure the image fills the frame
                            .frame(width: 110, height: 170) // Uniform size for all images
                            .clipped() // Ensure no overflow
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2) // White border with opacity
                            )
                            .shadow(radius: 5)
                            .offset(y: 10)
                            .zIndex(1) // Bring to the front

                        // First Image (frontmost)
                        Image(top3Images[0].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Ensure the image fills the frame
                            .frame(width: 110, height: 170) // Uniform size for all images
                            .clipped() // Ensure no overflow
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2) // White border with opacity
                            )
                            .shadow(radius: 5)
                            .rotationEffect(Angle(degrees: -20)) // Rotate slightly
                            .offset(x: -105, y: 30) // Move to the left
                            .zIndex(2) // Bring to the very front
                    }
                    .padding(.top, 10) // Add padding to prevent clipping
                    .frame(height: 200) // Ensure enough height for rotated images
                }




                Divider()
                    .padding(.vertical, 15) // Add vertical padding

                // Recently Watched Section
                VStack(alignment: .leading) {
                    HStack(spacing: 5) { // Added spacing
                        Text("Recently watched")
                            .font(.system(size: 16, weight: .bold, design: .rounded)) // Updated font
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Make the HStack fill available space
                    .padding(.horizontal, 10) // Add padding to increase the size visually

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recentlyWatched) { item in
                                Image(item.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill) // Ensure the image fills the frame
                                    .frame(width: 110, height: 170) // Uniform size for all images
                                    .clipped() // Ensures no overflow
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 2) // White border with opacity
                                    )
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal, 10) // Add horizontal padding
                    }
                    .frame(height: 200) // Set height for the ScrollView
                }
                .offset(y: -10)



            }
            .padding()
        }
        .background(
            ZStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 20) // Add blur to the background image
                        .overlay(Color.black.opacity(0.5)) // Dark overlay for better contrast
                        .edgesIgnoringSafeArea(.all) // Extend to the edges
                } else {
                    Color.black // Default background color if no image is selected
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $profileImage)
        }
        .sheet(isPresented: $isColorPickerPresented) {
            ColorPicker("Select Ring Color", selection: $ringColor)
                .padding()
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// Helper View for Stats
struct StatView: View {
    let title: String
    let count: String

    var body: some View {
        VStack {
            Text(count)
                .font(.system(size: 22, weight: .bold, design: .rounded)) // Updated font
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded)) // Updated font
                .foregroundColor(.gray)
        }
    }
}

// A model to represent an image with an ID
struct ImageItem: Identifiable {
    let id = UUID()
    let imageName: String
}

// Preview
#Preview {
    Profile()
}

