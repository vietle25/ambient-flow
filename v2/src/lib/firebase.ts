import { initializeApp, getApps, getApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCUHcD1lE_pRHm1iGr5_9gpVq6AzN805nQ",
  authDomain: "ambient-flow-d9e78.firebaseapp.com",
  projectId: "ambient-flow-d9e78",
  storageBucket: "ambient-flow-d9e78.firebasestorage.app",
  messagingSenderId: "685587131461",
  appId: "1:685587131461:web:2c5ecea7bb11da97dac72c",
  measurementId: "G-QGEHWJR4VS"
};

const app = getApps().length > 0 ? getApp() : initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();
export const db = getFirestore(app);
