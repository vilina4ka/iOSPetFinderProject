//
//  SupabaseClient.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 08.09.2025.
//

import UIKit
import Supabase

let supabaseURL = URL(string: "https://whbndtpcpbvgziwnccxn.supabase.co")!
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndoYm5kdHBjcGJ2Z3ppd25jY3huIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNzM3MDUsImV4cCI6MjA3Mjg0OTcwNX0.70OIlcAd7tLlhR4k103v1cZGIztQRsd7T0O7pPx8I6k"

let supabase = SupabaseClient(
  supabaseURL: supabaseURL,
  supabaseKey: supabaseKey
)
