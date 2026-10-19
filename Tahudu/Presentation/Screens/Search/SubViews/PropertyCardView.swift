//
//  PropertyCardView.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 17/10/2026.
//

import SwiftUI

struct PropertyCardView: View {
    private let listing: Listing
    private let isFavourite: Bool
    private let onFavouriteTapped: () -> Void

    init(
        listing: Listing,
        isFavourite: Bool,
        onFavouriteTapped: @escaping () -> Void
    ) {
        self.listing = listing
        self.isFavourite = isFavourite
        self.onFavouriteTapped = onFavouriteTapped
    }
    
    var body: some View {
      content
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            topCard
            
            secondDetailsCard
                .padding(.horizontal, 16)
            
            Divider()
            
            comunicationCard
            if listing.lastContactedAt != nil {
                lastContactedCard
            } else {
                Spacer()
            }
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 0.7)
        }
//        .padding(.horizontal, 16)
    }
    
    private var topCard: some View {
        ZStack(alignment: .top) {
            TabView {
                ForEach(listing.images, id: \.self) { name in
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 220)
            
            HStack {
                HStack {
                    ForEach(listing.tags, id: \.self) { tag in
                        Text(tag.title)
                            .font(.caption2)
                            .foregroundStyle(.white)
                            .padding(4)
                            .background {
                                tag.color
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
              Spacer()
                
                Button(action: onFavouriteTapped) {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .foregroundStyle(.white)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(.gray))
                }
                .accessibilityLabel(isFavourite ? "Remove from favourites" : "Add to favourites")
            }
            .padding(16)
        }
    }
    
    private var secondDetailsCard: some View {
        VStack (alignment: .leading, spacing: 8){
            HStack {
                Text(listing.type)
                    .font(.caption)
                    
                Text("Delivery: \(listing.deliveryYear)")
                    .font(.caption)
                    .foregroundStyle(Color.purple)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background {
                        Color.purple.opacity(0.1)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                
            }
            
            Text("\(listing.price.formatted(.number)) \(listing.currency)")
                .font(.headline)
            
            HStack {
                Image(systemName: "bed.double")
                    .font(.system(size: 14))
                
                if let beds = listing.bedrooms {
                    Text("\(beds) Beds")
                        .font(.caption)
                } else {
                    Text("Studio")
                        .font(.caption)
                }
                
            }
            
        }
    }
    
    private var comunicationCard: some View {
        HStack {
            Text("Published \(listing.publishedAt.timeAgo)")
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.9))
            
            Spacer()
            
            HStack {
                if listing.contactOptions.contains(.phone) {
                    ContactButton(.phone) {
                        print("phone")
                    }
                }
                
                if listing.contactOptions.contains(.email) {
                    ContactButton(.email) {
                        print("mail")
                    }
                }
                
                if listing.contactOptions.contains(.whatsApp) {
                    ContactButton(.whatsApp) {
                        print("whatsapp")
                    }
                }

            }
        }
        
        .padding(.horizontal, 16)
    }
    
    private var lastContactedCard: some View {
        HStack(spacing: 0) {
            Image(systemName: "phone.fill")
                .font(.system(size: 12))
            
            Text(" Last conntacted: \(listing.lastContactedAt?.showDate ?? "")")
                .font(.caption)
                .foregroundStyle(.black)
                .padding(.vertical, 4)
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.yellow.opacity(0.3)
        }
    }
}

#Preview {
    PropertyCardView(listing: .sample, isFavourite: false) {}
}
