/* Onboarding Logic v2 — Multi-step with BZ Flair */

document.addEventListener('DOMContentLoaded', () => {
    let currentStep = 1;
    const totalSteps = 3;

    // Elements
    const dots = document.querySelectorAll('.step-dot');
    const steps = document.querySelectorAll('.step-content');
    const roleOpts = document.querySelectorAll('.role-opt');
    const tagChips = document.querySelectorAll('.tag-chip');
    const successPanel = document.getElementById('onboard-success');

    // Navigation
    function goToStep(step) {
        steps.forEach(s => s.classList.remove('active'));
        dots.forEach(d => d.classList.remove('active'));
        
        document.getElementById(`step-${step}`).classList.add('active');
        document.querySelector(`.step-dot[data-step="${step}"]`).classList.add('active');
        currentStep = step;
    }

    // Handlers
    document.getElementById('form-step-1').onsubmit = (e) => {
        e.preventDefault();
        // Here we would call Clerk / Convex Sign Up
        // const email = document.getElementById('email').value;
        // const password = document.getElementById('password').value;
        goToStep(2);
    };

    document.getElementById('form-step-2').onsubmit = (e) => {
        e.preventDefault();
        goToStep(3);
    };

    document.getElementById('back-to-1').onclick = () => goToStep(1);

    // Role selection
    roleOpts.forEach(opt => {
        opt.onclick = () => {
            roleOpts.forEach(o => o.classList.remove('active'));
            opt.classList.add('active');
        };
    });

    // Tag selection
    tagChips.forEach(chip => {
        chip.onclick = () => {
            chip.classList.toggle('active');
        };
    });

    // Finish
    document.getElementById('finish-btn').onclick = () => {
        // Here we would push the profile to Convex
        successPanel.classList.add('active');
    };

    // Password strength
    const passwordInput = document.getElementById('password');
    const pwBar = document.getElementById('pw-bar');
    if (passwordInput) {
        passwordInput.oninput = () => {
            const val = passwordInput.value;
            let strength = 0;
            if (val.length > 5) strength += 30;
            if (val.length > 8) strength += 40;
            if (/[0-9]/.test(val)) strength += 15;
            if (/[!@#$%^&*]/.test(val)) strength += 15;

            pwBar.style.width = strength + '%';
            pwBar.style.background = strength < 40 ? 'var(--danger)' : strength < 80 ? 'var(--accent)' : 'var(--success)';
        };
    }
});
