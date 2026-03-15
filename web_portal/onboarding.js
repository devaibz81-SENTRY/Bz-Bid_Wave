import { ConvexClient } from "convex/browser";

document.addEventListener('DOMContentLoaded', async () => {
    // Convex Client Initialization
    const client = new ConvexClient("https://zealous-orca-596.convex.cloud");
    const successPanel = document.getElementById('onboard-success');

    const clerkPublishableKey = "pk_test_d2VsY29tZS1zbmFpbC02NC5jbGVyay5hY2NvdW50cy5kZXYk";
    const frontendApi = "welcome-snail-64.clerk.accounts.dev";

    const script = document.createElement("script");
    script.setAttribute("data-clerk-publishable-key", clerkPublishableKey);
    script.async = true;
    script.src = `https://${frontendApi}/npm/@clerk/clerk-js@latest/clerk.browser.js`;
    script.crossOrigin = "anonymous";

    script.addEventListener("load", async function () {
        await window.Clerk.load({
            // Initialize Clerk
        });

        const mountNode = document.getElementById('clerk-mount');
        
        if (window.Clerk.user) {
            handleAuthenticatedUser();
        } else {
            // User not signed in, mount the Sign Up component
            window.Clerk.mountSignUp(mountNode, {
                afterSignUpUrl: window.location.href, // Triggers reload/auth state change
                afterSignInUrl: window.location.href,
            });
        }

        // Listener for changes (like successful sign-up completion)
        window.Clerk.addListener(async ({ user }) => {
            if (user) {
                handleAuthenticatedUser();
            }
        });
    });
    
    document.body.appendChild(script);

    async function handleAuthenticatedUser() {
        // Hide the clerk mount and steps
        const step1 = document.getElementById('step-1');
        if(step1) step1.classList.remove('active');
        
        const stepsProgress = document.getElementById('steps-progress');
        if(stepsProgress) stepsProgress.style.display = 'none';

        // Retrieve the Convex JWT from Clerk
        const token = await window.Clerk.session.getToken({ template: 'convex' });
        client.setAuth(async () => token);

        try {
            // Register the user footprint in our Convex DB
            const userName = window.Clerk.user.fullName || window.Clerk.user.firstName || "Bidder " + window.Clerk.user.id.substring(0, 5);
            
            const userId = await client.mutation("auth:storeClerkUser", {
                name: userName,
                role: "bidder",
                tags: []
            });

            // Save basic public session info locally for optimistic UI updates in chat/dashboard
            localStorage.setItem('bz_user_id', userId);
            localStorage.setItem('bz_user_name', userName);

            // Show Success Panel
            if(successPanel) successPanel.classList.add('active');
        } catch (err) {
            console.error("Failed to sync user with Convex:", err);
            alert("There was an issue syncing your profile. Please try refreshing.");
        }
    }
});
