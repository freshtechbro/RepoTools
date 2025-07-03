import React from 'react';

interface RepotoolsLogoProps {
  size?: number;
  className?: string;
}

export const RepotoolsLogo: React.FC<RepotoolsLogoProps> = ({ 
  size = 24, 
  className = "" 
}) => {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      {/* Background circle with gradient effect */}
      <defs>
        <linearGradient id="repotoolsGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="currentColor" stopOpacity="1" />
          <stop offset="100%" stopColor="currentColor" stopOpacity="0.8" />
        </linearGradient>
      </defs>
      
      {/* Letter R with diagonal slant */}
      <g transform="rotate(-15 12 12)">
        {/* Vertical stroke of R */}
        <rect
          x="6"
          y="4"
          width="2.5"
          height="16"
          fill="currentColor"
          rx="1.25"
        />
        
        {/* Top horizontal stroke of R */}
        <rect
          x="6"
          y="4"
          width="8"
          height="2.5"
          fill="currentColor"
          rx="1.25"
        />
        
        {/* Middle horizontal stroke of R */}
        <rect
          x="6"
          y="10.75"
          width="6"
          height="2.5"
          fill="currentColor"
          rx="1.25"
        />
        
        {/* Right vertical stroke (top part) */}
        <rect
          x="11.5"
          y="4"
          width="2.5"
          height="9.25"
          fill="currentColor"
          rx="1.25"
        />
        
        {/* Diagonal leg of R */}
        <rect
          x="10"
          y="12"
          width="2.5"
          height="9"
          fill="currentColor"
          rx="1.25"
          transform="rotate(25 11.25 16.5)"
        />
        
        {/* Curved corner for top right */}
        <circle
          cx="13.25"
          cy="8.5"
          r="4.25"
          fill="none"
          stroke="currentColor"
          strokeWidth="2.5"
          strokeLinecap="round"
          clipPath="url(#topRightClip)"
        />
      </g>
      
      {/* Clip path for the curved corner */}
      <defs>
        <clipPath id="topRightClip">
          <rect x="11.5" y="4" width="6" height="9.25" />
        </clipPath>
      </defs>
    </svg>
  );
};

// Alternative simpler version
export const RepotoolsLogoSimple: React.FC<RepotoolsLogoProps> = ({ 
  size = 24, 
  className = "" 
}) => {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      {/* Simple R with diagonal slant */}
      <g transform="rotate(-15 12 12)">
        <path
          d="M7 5 L7 19 M7 5 L15 5 Q17 5 17 8 Q17 11 15 11 L7 11 M11 11 L16 19"
          stroke="currentColor"
          strokeWidth="2.5"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        />
      </g>
    </svg>
  );
};

// Text-based version for consistency
export const RepotoolsLogoText: React.FC<RepotoolsLogoProps> = ({ 
  size = 24, 
  className = "" 
}) => {
  const fontSize = size * 0.8;
  
  return (
    <div
      className={`flex items-center justify-center ${className}`}
      style={{
        width: size,
        height: size,
        transform: 'rotate(-15deg)',
      }}
    >
      <span
        style={{
          fontSize: `${fontSize}px`,
          fontWeight: 'bold',
          color: 'currentColor',
          fontFamily: 'system-ui, -apple-system, sans-serif',
        }}
      >
        R
      </span>
    </div>
  );
};
