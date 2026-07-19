import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

initializeApp(); // ①

export const db = getFirestore(); // ②
