import { ActionContext, UserFacingError } from "genkit";

export function requireAuth(context: ActionContext | undefined): string {
  const auth = context?.auth;
  if (!auth) {
    throw new UserFacingError("UNAUTHENTICATED", "認証が必要です");
  }
  return auth.uid;
}
