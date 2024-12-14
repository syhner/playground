import {
	useEffect,
	useState,
	useContext,
	createContext,
	type PropsWithChildren,
} from "react";
import * as WebBrowser from "expo-web-browser";
import { makeRedirectUri, useAuthRequest } from "expo-auth-session";
// import { createClient } from "@openauthjs/openauth/client";
// import { subjects } from "../../auth/src/subjects"; // bad import

const AuthContext = createContext<{
	signIn: () => void;
	signOut: () => void;
	session?: string | null;
	isLoading: boolean;
}>({
	signIn: () => null,
	signOut: () => null,
	session: null,
	isLoading: false,
});

WebBrowser.maybeCompleteAuthSession();

// Endpoint
const discovery = {
	authorizationEndpoint: `${process.env.AUTH_ISSUER}/authorize`,
	tokenEndpoint: `${process.env.AUTH_ISSUER}/token`,
};

// This hook can be used to access the user info.
export function useSession() {
	const value = useContext(AuthContext);
	if (process.env.NODE_ENV !== "production") {
		if (!value) {
			throw new Error("useSession must be wrapped in a <SessionProvider />");
		}
	}

	return value;
}

// export const client = createClient({
// 	clientID: "expo",
// 	issuer: process.env.AUTH_ISSUER,
// });

export function SessionProvider({ children }: PropsWithChildren) {
	const [session, setSession] = useState(null);
	const [isLoading, setIsLoading] = useState(false);
	const [request, response, promptAsync] = useAuthRequest(
		{
			clientId: "expo",
			redirectUri: makeRedirectUri({
				scheme: "your.app",
			}),
		},
		discovery,
	);

	useEffect(() => {
		async function e() {
			if (response?.type === "success") {
				const accessToken = response.authentication?.accessToken;

				if (accessToken) {
					const refreshToken = response.authentication?.refreshToken;
					// const verified = await client.verify(subjects, accessToken, {
					// 	refresh: refreshToken,
					// });
					// if (!verified.err) {
					// 	setSession(verified.subject);
					// }
				}
				setIsLoading(false);
			}
		}
		e();
	}, [response]);

	return (
		<AuthContext.Provider
			value={{
				signIn: () => {
					// Perform sign-in logic here
					setIsLoading(true);
					promptAsync();
				},
				signOut: () => {
					setSession(null);
				},
				session,
				isLoading,
			}}
		>
			{children}
		</AuthContext.Provider>
	);
}
